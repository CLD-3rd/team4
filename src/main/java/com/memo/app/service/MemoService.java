package com.memo.app.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.memo.app.dto.Memo;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.Duration;
import java.util.UUID;

@Service
public class MemoService {

    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;

    public MemoService(StringRedisTemplate redisTemplate, ObjectMapper objectMapper) {
        this.redisTemplate = redisTemplate;
        this.objectMapper = objectMapper;
    }

    public Memo createMemo(String text, String imageUrl) throws IOException {
        String id = UUID.randomUUID().toString(); // 순수 UUID 생성
        String memoId = "memo:" + id; // Redis에 사용할 키
        
        Memo memo = new Memo();
        memo.setId(id); // 클라이언트에게는 순수 UUID를 반환
        memo.setText(text);

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
        return memo;
    }
}
