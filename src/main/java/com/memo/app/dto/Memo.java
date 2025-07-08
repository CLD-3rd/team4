package com.memo.app.dto;

import lombok.Data;

@Data
public class Memo {
    private String id;
    private String text;
    private long ttl;
}
