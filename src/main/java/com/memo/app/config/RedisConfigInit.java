package com.memo.app.config;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class RedisConfigInit {

    private final StringRedisTemplate redisTemplate;

    @PostConstruct
    public void init() {
        redisTemplate.getConnectionFactory().getConnection()
            .setConfig("notify-keyspace-events", "Ex");
    }
}