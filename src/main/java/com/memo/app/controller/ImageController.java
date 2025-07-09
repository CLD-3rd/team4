package com.memo.app.controller;

import com.memo.app.service.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/image")
public class ImageController {

    private final S3Service s3Uploader;

    // 이미지 업로드
    @PostMapping("/upload")
    public ResponseEntity<?> upload(@RequestPart("image") MultipartFile image) {
        try {
            String imageUrl = s3Uploader.upload(image);
            return ResponseEntity.ok().body(imageUrl);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("업로드 실패: " + e.getMessage());
        }
    }
}
