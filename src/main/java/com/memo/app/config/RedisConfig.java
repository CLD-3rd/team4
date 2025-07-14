package com.memo.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;

import com.memo.app.listener.RedisKeyExpirationListener;
import com.memo.app.service.S3Service;

@Configuration
public class RedisConfig {

    @Bean
    public RedisKeyExpirationListener redisKeyExpirationListener(
        RedisTemplate<String, String> redisTemplate,
        S3Service s3Service
    ) {
        return new RedisKeyExpirationListener(redisTemplate, s3Service);
    }

    @Bean
    public RedisMessageListenerContainer redisMessageListenerContainer(
        RedisConnectionFactory connectionFactory,
        RedisKeyExpirationListener expirationListener
    ) {
        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);
        container.addMessageListener(expirationListener, new PatternTopic("__keyevent@0__:expired"));
        return container;
    }
}