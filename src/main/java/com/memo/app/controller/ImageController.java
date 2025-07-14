package com.memo.app.controller;

import com.memo.app.entity.MemoList;
import com.memo.app.repository.MemoListRepository;
import com.memo.app.service.S3Service;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/image")
public class ImageController {

    private final S3Service s3Service;
    private final MemoListRepository memoListRepository;

    @GetMapping("/download/{memoId}")
    public ResponseEntity<byte[]> downloadImage(@PathVariable String memoId) throws IOException {
        MemoList memo = memoListRepository.findById(memoId)
                .orElseThrow(() -> new RuntimeException("Memo not found with id: " + memoId));

        if (memo.getFileUrl() == null || memo.getOriginalFileName() == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }

        String s3Key = s3Service.extractKeyFromUrl(memo.getFileUrl());
        if (s3Key == null) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }

        byte[] data = s3Service.downloadFile(s3Key);
        String fileName = URLEncoder.encode(memo.getOriginalFileName(), StandardCharsets.UTF_8.toString());

        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        header.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"");

        return new ResponseEntity<>(data, header, HttpStatus.OK);
    }
}
