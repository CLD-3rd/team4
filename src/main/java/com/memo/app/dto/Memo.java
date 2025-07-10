package com.memo.app.dto;

import lombok.Data;

@Data
public class Memo {
    private String id;
    private String text;
    private long ttl;
    private String imageUrl;
    private String fileName;
    private int viewLimit; // 0=무제한, 1=1회 열람
    private int viewCount = 0;
}