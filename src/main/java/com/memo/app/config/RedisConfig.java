package com.memo.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;

import com.memo.app.listener.RedisKeyExpirationListener;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class RedisConfig {

    private final RedisKeyExpirationListener redisKeyExpirationListener;
    private final RedisConnectionFactory redisConnectionFactory;

    @Bean
    public RedisMessageListenerContainer redisMessageListenerContainer() {
        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        container.setConnectionFactory(redisConnectionFactory);

        // "expired" 이벤트 리스너 등록
        container.addMessageListener(
            redisKeyExpirationListener,
            new PatternTopic("__keyevent@0__:expired")
        );

        return container;
    }
}