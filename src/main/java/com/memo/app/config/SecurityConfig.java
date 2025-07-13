package com.memo.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(authorize -> authorize
                .requestMatchers(
                	// "/api/**" // 포스트맨 테스트할때에는 허용
                    // 인증 관련 페이지
                    "/login", "/login.html", "/signup", "/signup.html",
                    // 메모 조회 페이지 (forward 경로와 실제 파일 경로 모두 포함)
                    "/view", "/view.html",
                    // 정적 리소스
                    "/static/**", "/css/**", "/js/**", "/images/**",
                    // 이미지 다운로드
                    "/api/image/download/**"
                ).permitAll()
                // 메모 조회 API (GET 요청만 허용)
                .requestMatchers(HttpMethod.GET, "/api/notes/**").permitAll()
                // 그 외 모든 요청은 인증 필요
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .usernameParameter("uid")
                .passwordParameter("upw")
                .defaultSuccessUrl("/list", true)
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout")
                .permitAll()
            );
        return http.build();
    }
}
