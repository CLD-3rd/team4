package com.memo.app.listener;

import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.memo.app.service.S3Service;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class RedisKeyExpirationListener implements MessageListener {

    private final RedisTemplate<String, String> redisTemplate;
    private final S3Service s3Service;

    @Override
    public void onMessage(Message message, byte[] pattern) {
        String expiredKey = message.toString();
        System.out.println("만료된 Memo key: " + expiredKey);
        
        // memo: prefix 확인
        if (!expiredKey.startsWith("memo:")) {
            System.out.println("메모 키가 아님, 무시: " + expiredKey);
            return;
        }
        
        // memoId 추출 + imageKey 정의
        String memoId = expiredKey.replace("memo:", "");
        String imageKey = "image:" + memoId;

        try {
            // image key에 저장된 URL 조회
            String imageUrl = redisTemplate.opsForValue().get(imageKey);

            if (imageUrl != null && !imageUrl.isBlank()) {
            	s3Service.delete(imageUrl);

                // image:{id} 키도 삭제해줌
                redisTemplate.delete(imageKey);
                System.out.println("Image Key 삭제 완료: " + imageKey);
            } else {
                System.out.println("imageUrl이 없음 또는 TTL 만료됨: " + imageKey);
            }

        } catch (Exception e) {
            System.err.println("만료된 메모 처리 중 오류 발생");
            e.printStackTrace();
        }
    }
}