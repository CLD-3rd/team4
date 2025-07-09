package com.memo.app.listener;

import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.memo.app.service.S3Service;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class RedisKeyExpirationListener implements MessageListener {

    private final RedisTemplate<String, String> redisTemplate;
    private final S3Service s3Service;

    @Override
    public void onMessage(Message message, byte[] pattern) {
        String expiredKey = message.toString(); // e.g., memo:123
        if (!expiredKey.startsWith("memo:")) return;

        try {
            String imageUrl = (String) redisTemplate.opsForHash().get(expiredKey, "imageUrl");
            if (imageUrl != null && !imageUrl.isBlank()) {
                s3Service.delete(imageUrl);
                System.out.println("Deleted image from S3: " + imageUrl);
            }
        } catch (Exception e) {
            System.err.println("Redis key expired, but failed to delete image");
            e.printStackTrace();
        }
    }
}