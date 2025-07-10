# Pung! - Private Memo Sharing Service

## 1. 최근 주요 업데이트 내역

이번 업데이트는 DB 연동, 동적 TTL 기능, 파일 첨부 기능 개선 등 핵심 기능 구현과 사용자 경험 향상에 중점을 두었습니다.

### 1.1. DB Write-Through 기능 구현 및 메모 목록 연동

-   **목표**: 메모 메타데이터를 DB에 영속적으로 저장하고, 사용자별 메모 목록을 제공합니다.
-   **변경 사항**:
    -   **`MemoService.createMemo`**: 메모 생성 시 Redis와 함께 **MariaDB `memo_list` 테아블에도 메타데이터를 저장**하도록 변경했습니다. (Write-Through)
    -   **`MemoController`**: 로그인한 사용자의 메모 목록을 DB에서 조회하여 반환하는 **`GET /api/notes/list`** 엔드포인트를 추가했습니다.
    -   **`list.html`**: API 호출 대상을 `/api/notes/list`로 변경하여, DB 기반의 실제 메모 목록을 표시하도록 수정했습니다.

### 1.2. 동적 TTL(만료 시간) 설정 기능

-   **목표**: 사용자가 직접 메모의 만료 시간을 '프리셋' 또는 '직접 입력'으로 설정할 수 있도록 합니다.
-   **사용법**:
    -   `write.html` 페이지에서 '프리셋' 버튼을 클릭하거나, '직접 입력' 탭에서 시간과 단위를 설정합니다.
    -   '저장 및 링크 생성' 버튼을 누르면 설정된 만료 시간이 적용됩니다. (기본값: 1분)
-   **변경 사항**:
    -   **`write.html`**: 사용자가 선택한 TTL 값을 **분 단위로 계산**하여 `ttlMinutes` 파라미터로 서버에 전송하는 JavaScript 로직을 추가했습니다.
    -   **`MemoController.createMemo`**: `@RequestParam("ttlMinutes")`를 추가하여 클라이언트가 보낸 TTL 값을 받습니다.
    -   **`MemoService.createMemo`**: 전달받은 `ttlMinutes`를 기반으로 Redis와 DB(`expire_at` 필드)에 동적 만료 시간을 설정합니다. 이로써 TTL로 만료된 메모도 목록에서 '만료됨'으로 올바르게 표시됩니다.

### 1.3. 파일 첨부 기능 개선

-   **목표**: 파일 첨부 UI를 개선하고, 이미지 외 다양한 파일을 처리할 수 있도록 기반을 마련합니다.
-   **사용법**:
    -   `write.html`에서 '파일 첨부' 버튼을 눌러 파일을 선택하면, 버튼 **위에** 선택된 파일명이 표시됩니다.
    -   생성된 메모 조회 시(`view.html`), 첨부된 파일은 이미지가 아닌 **파일명 텍스트**로 표시됩니다.
-   **유의사항**:
    -   레이아웃이 밀리는 현상을 방지하기 위해, 파일명이 표시될 공간에 `min-height`를 설정해두었습니다. 따라서 파일 선택 전에는 해당 영역이 비어있는 것처럼 보입니다.
-   **주요 코드 변경**:
    -   **`MemoList.java` (Entity)**: 원본 파일명을 저장하기 위해 `originalFileName` 컬럼을 추가했습니다.
    -   **`MemoService.createMemo`**: `MultipartFile`에서 원본 파일명을 추출하여 DB에 저장하도록 수정했습니다.
    -   **`view.html`**: 기존 `<img>` 태그를 파일명을 표시하는 `<div>`로 교체했습니다.
    -   **`write.html`**: 파일명 표시를 위한 `div`를 추가하고, 선택 시 파일명을 표시하는 JavaScript 로직을 수정했습니다.

### 1.4. 1회 열람 제한 기능

-   **목표**: 사용자가 생성하는 메모를 수신자가 단 한 번만 열람할 수 있도록 제한하는 기능을 프론트와 연결합니다.
-   **사용법**:
    -   `write.html` 페이지 하단의 **'열람 횟수 1회로 제한' 체크박스를 선택**하고 메모를 생성합니다.
-   **주요 코드 변경 및 로직**:
    -   **`write.html`**:
        -   체크박스의 상태(`checked`)를 확인하여, `viewLimit` 파라미터 값을 `'1'`(체크 시) 또는 `'0'`(미체크 시)으로 설정하여 서버에 전송합니다.
        ```javascript
        const isOnceOnly = document.getElementById('once-only-check').checked;
        formData.append('viewLimit', isOnceOnly ? '1' : '0');
        ```
    -   **`MemoService.createMemo`**:
        -   전달받은 `viewLimit` 값을 `memo_list` 테이블의 `view_limit` 컬럼에 저장합니다.
    -   **`MemoService.getMemo` (핵심 로직)**:
        -   1회 열람 제한이 걸린 메모가 조회될 때, 단순 삭제가 아닌 **상태 변경** 방식으로 처리하여 데이터 정합성을 확보했습니다.
        -   메모 조회 시, DB에서 해당 메모의 `view_count`를 1 증가시킵니다.
        -   그 후, `viewLimit`이 1인 메모리의 경우, **DB의 `is_deleted` 플래그를 `true`로 업데이트**합니다.
        -   마지막으로 Redis에 캐시된 메모 데이터와 S3의 파일을 삭제하여, 다음 접근부터는 조회가 불가능하도록 만듭니다.
        ```java
        // in getMemo()
        if (memo.getViewLimit() == 1 && newCount >= 1) {
            memoList.setIsDeleted(true); // DB에 삭제 플래그 설정
            memoListRepository.save(memoList); // DB 업데이트

            redisTemplate.delete(memoId); // Redis 데이터 삭제
            // ... S3 파일 삭제 로직 ...
        }
        ```
    -   **`list.html`**:
        -   메모 목록을 표시할 때, `isDeleted` 플래그가 `true`인 메모는 '만료됨'으로 표시하고 클릭할 수 없도록 처리하여, 사용자가 만료 상태를 명확히 인지할 수 있도록 했습니다.

### 1.5. UI/UX 및 기타 버그 수정

-   **URL `.html` 확장자 제거**: `WebConfig`의 `addViewControllers` 설정을 통해, 모든 페이지의 URL에서 `.html` 확장자를 제거하여 주소를 깔끔하게 개선했습니다. (예: `/write.html` -> `/write`)
-   **조회수/만료 상태 동기화**: `MemoService.getMemo`에서 메모 조회 시, Redis와 DB의 `viewCount` 상태를 함께 업데이트하여 데이터 정합성을 맞추고, 목록에 최신 상태가 반영되도록 버그를 수정했습니다.
-   **네비게이션 바 통일**: 모든 페이지에 일관된 네비게이션 바를 적용하고, 사용자 이름이 항상 표시되도록 수정했습니다.
-   URL 파라미터를 **프래그먼트(#)** 대신 쿼리스트링(?key=value)으로 변경했습니다. 
