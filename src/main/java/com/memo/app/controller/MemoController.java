package com.memo.app.controller;

import java.io.IOException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.memo.app.dto.Memo;
import com.memo.app.service.MemoService;
import com.memo.app.service.S3Service;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/notes")
public class MemoController {

    private final MemoService memoService;
    private final S3Service s3Service;

    @PostMapping
    public ResponseEntity<Memo> createMemo(
            @RequestPart("text") String text,
            @RequestPart(value = "image", required = false) MultipartFile image
    ) throws IOException {
        String imageUrl = null;

        if (image != null && !image.isEmpty()) {
            imageUrl = s3Service.upload(image);
        }

        Memo memo = memoService.createMemo(text, imageUrl);
        return ResponseEntity.status(HttpStatus.CREATED).body(memo);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Memo> getMemo(@PathVariable String id) throws IOException {
        Memo memo = memoService.getMemo(id);
        if (memo == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(memo);
    }
}
