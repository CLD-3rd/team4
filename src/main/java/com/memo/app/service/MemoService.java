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
        String id = UUID.randomUUID().toString();
        String memoId = "memo:" + id;
        Memo memo = new Memo();
        memo.setId(memoId);
        memo.setText(text);
        
        if (imageUrl != null) {
        	memo.setImageUrl(imageUrl);
        }

        long ttl = Duration.ofSeconds(10).getSeconds();
        memo.setTtl(ttl);

        String memoJson = objectMapper.writeValueAsString(memo);
        redisTemplate.opsForValue().set(memoId, memoJson, Duration.ofSeconds(ttl));
        redisTemplate.opsForValue().set("image:" + id, imageUrl);

        return memo;
    }

    public Memo getMemo(String id) throws IOException {
    	String memoId = "memo:" + id;
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
