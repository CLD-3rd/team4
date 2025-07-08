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

    public Memo createMemo(String text) throws IOException {
        String id = UUID.randomUUID().toString();
        Memo memo = new Memo();
        memo.setId(id);
        memo.setText(text);

        long ttl = Duration.ofHours(24).getSeconds();
        memo.setTtl(ttl);

        String memoJson = objectMapper.writeValueAsString(memo);
        redisTemplate.opsForValue().set(id, memoJson, Duration.ofSeconds(ttl));

        return memo;
    }

    public Memo getMemo(String id) throws IOException {
        String memoJson = redisTemplate.opsForValue().get(id);
        if (memoJson == null) {
            return null;
        }
        Memo memo = objectMapper.readValue(memoJson, Memo.class);
        Long ttl = redisTemplate.getExpire(id);
        memo.setTtl(ttl);
        return memo;
    }
}
