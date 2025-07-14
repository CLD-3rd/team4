package com.memo.app.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/login").setViewName("forward:/login.html");
        registry.addViewController("/signup").setViewName("forward:/signup.html");
        registry.addViewController("/write").setViewName("forward:/write.html");
        registry.addViewController("/view").setViewName("forward:/view.html");
        registry.addViewController("/list").setViewName("forward:/list.html");
        registry.addViewController("/").setViewName("forward:/write.html");
    }
}
