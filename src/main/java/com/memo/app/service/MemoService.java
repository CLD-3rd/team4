
package com.memo.app.service;

import java.io.IOException;
import java.time.Duration;
import java.util.UUID;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.memo.app.dto.Memo;
import com.memo.app.entity.MemoList;
import com.memo.app.entity.User;
import com.memo.app.repository.MemoListRepository;
import com.memo.app.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemoService {

    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;
    private final S3Service s3Service;
    private final MemoListRepository memoListRepository;
    private final UserRepository userRepository;

//    public MemoService(StringRedisTemplate redisTemplate, ObjectMapper objectMapper) {
//        this.redisTemplate = redisTemplate;
//        this.objectMapper = objectMapper;
//    }

    public Memo createMemo(String text, String imageUrl, String originalFileName, int viewLimit, String title, int ttlMinutes) throws IOException {
        String id = UUID.randomUUID().toString(); // 순수 UUID 생성
        String memoId = "memo:" + id; // Redis에 사용할 키
        
        Memo memo = new Memo();
        memo.setId(id); // 클라이언트에게는 순수 UUID를 반환
        memo.setText(text);
        memo.setViewLimit(viewLimit);
        
        Duration ttl = Duration.ofMinutes(ttlMinutes);
        memo.setTtl(ttl.toSeconds());

        if (imageUrl != null) {
            memo.setImageUrl(imageUrl);
            memo.setFileName(originalFileName);
            redisTemplate.opsForValue().set("image:" + id, imageUrl);
        }

        String memoJson = objectMapper.writeValueAsString(memo);
        redisTemplate.opsForValue().set(memoId, memoJson, ttl);

        // DB에 저장
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUserId = authentication.getName();
        User user = userRepository.findByUid(currentUserId).orElseThrow(() -> new RuntimeException("User not found"));

        MemoList memoList = new MemoList();
        memoList.setMemoId(id);
        memoList.setUser(user);
        memoList.setMemoTitle(title);
        memoList.setViewLimit(viewLimit);
        memoList.setFileUrl(imageUrl);
        memoList.setOriginalFileName(originalFileName);
        
        memoList.setTtlMinutes(ttlMinutes);
        if (ttlMinutes > 0) {
            memoList.setExpireAt(java.time.LocalDateTime.now().plusMinutes(ttlMinutes));
        }

        memoListRepository.save(memoList);

        return memo;
    }

    public Memo getMemo(String id) throws IOException {
        String memoId = "memo:" + id; // 순수 UUID에 접두사를 붙여 Redis 키를 만듦
        String memoJson = redisTemplate.opsForValue().get(memoId);
        if (memoJson == null) {
            return null;
        }

        Memo memo = objectMapper.readValue(memoJson, Memo.class);
        Long ttl = redisTemplate.getExpire(memoId);
        memo.setTtl(ttl);

        // DB에서 MemoList 정보 가져오기
        MemoList memoList = memoListRepository.findById(id).orElse(null);
        if (memoList != null) {
            // 현재 로그인된 사용자 정보 가져오기 
            User currentUser = getCurrentUser();
            
            // 메모 작성자와 현재 사용자가 같은지 확인
            boolean isWriter = currentUser!=null&&memoList.getUser().getUid().equals(currentUser.getUid());
            
            memo.setViewCount(memoList.getViewCount());
            memo.setFileName(memoList.getOriginalFileName());
            
            // 작성자가 아닌 경우에만(로그인이 안되어있거나 다른 user) viewCount 증가
            if (!isWriter) {
                int newCount = memoList.getViewCount() + 1;
                memoList.setViewCount(newCount);
                memo.setViewCount(newCount);
                memoListRepository.save(memoList); // DB 업데이트

                // viewLimit == 1인 경우: 1회 조회 후 삭제
                if (memo.getViewLimit() == 1) {
                    memoList.setIsDeleted(true);	// DB에 삭제 플래그 설정
                    memoListRepository.save(memoList);

                    // Redis 메모 키 삭제
                    redisTemplate.delete(memoId);

                    // 이미지 삭제
                    if (memo.getImageUrl() != null) {
                        String imageKey = "image:" + id;
                        String imageUrl = redisTemplate.opsForValue().get(imageKey);
                        redisTemplate.delete(imageKey);
                        if (imageUrl != null) {
                            s3Service.delete(imageUrl);
                        }
                    }                    
                    return memo;  // 삭제되기 전의 내용을 담은 DTO 반환
                } 
                // viewLimit == 0인 경우: 무제한 조회
                else {
                    memoListRepository.save(memoList);
                    redisTemplate.opsForValue().set(memoId, objectMapper.writeValueAsString(memo), Duration.ofSeconds(ttl));
                    return memo;
                }
            } else {
                // 작성자 본인이 조회하는 경우 - viewCount 증가하지 않음
                return memo;
            }
        }
        // DB에 해당 메모없으면 Redis의 내용만 반환 (정상적인 상황은 아님)
        return memo;
    }

    public java.util.List<com.memo.app.entity.MemoList> getMyMemos() {
        User currentUser = getCurrentUser();
        return memoListRepository.findByUserOrderByCreatedAtDesc(currentUser);
    }
    
    // 현재 로그인된 사용자 정보 가져오기
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        // 인증 정보가 없거나 인증되지 않은 경우
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }
        String currentUserId = authentication.getName();
        return userRepository.findByUid(currentUserId)
                .orElseThrow(() -> new RuntimeException("User not found: " + currentUserId));
    }
}

