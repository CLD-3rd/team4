
package com.memo.app.service;

import java.io.IOException;
import java.time.Duration;
import java.util.UUID;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.memo.app.dto.Memo;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemoService {

    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;
    private final S3Service s3Service;

//    public MemoService(StringRedisTemplate redisTemplate, ObjectMapper objectMapper) {
//        this.redisTemplate = redisTemplate;
//        this.objectMapper = objectMapper;
//    }

    public Memo createMemo(String text, String imageUrl,int viewLimit) throws IOException {
        String id = UUID.randomUUID().toString(); // 순수 UUID 생성
        String memoId = "memo:" + id; // Redis에 사용할 키
        
        Memo memo = new Memo();
        memo.setId(id); // 클라이언트에게는 순수 UUID를 반환
        memo.setText(text);
        memo.setViewLimit(viewLimit);
        long ttlInSeconds = 60;
        Duration ttl = Duration.ofSeconds(ttlInSeconds);
        memo.setTtl(ttlInSeconds);

        if (imageUrl != null) {
            memo.setImageUrl(imageUrl);
            redisTemplate.opsForValue().set("image:" + id, imageUrl);
        }

        String memoJson = objectMapper.writeValueAsString(memo);
        redisTemplate.opsForValue().set(memoId, memoJson, ttl);

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
        
        int newCount = memo.getViewCount() + 1;
        memo.setViewCount(newCount);

        // viewLimit == 1 && viewCount >= 1 (1회열람 허용된 메모를 1회이상 조회시)
        if (memo.getViewLimit() == 1 && newCount >= 1) {
        	
        	// 삭제 전 반환할 객체 복사
        	Memo returnMemo = new Memo();
            returnMemo.setId(memo.getId());
            returnMemo.setText(memo.getText());
            returnMemo.setImageUrl(memo.getImageUrl());
            returnMemo.setViewCount(newCount);
            returnMemo.setViewLimit(memo.getViewLimit());
            returnMemo.setTtl(ttl);
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

            // 삭제 후 복사해둔 메모 반환
            return returnMemo;
        } else {
            // viewCount만 업데이트
            redisTemplate.opsForValue().set(memoId, objectMapper.writeValueAsString(memo), Duration.ofSeconds(ttl));
            return memo;
        }
    }
}

