package com.memo.app.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "memo_list")
public class MemoList {

    @Id
    @Column(name = "memo_id", length = 100)
    private String memoId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userno", nullable = false)
    private User user;

    @Column(name = "memo_title", length = 200)
    private String memoTitle;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "ttl_minutes")
    private Integer ttlMinutes;

    @Column(name = "expire_at")
    private LocalDateTime expireAt;

    @Column(name = "file_url", length = 2048)
    private String fileUrl;
}
