
package com.memo.app.controller;

import java.io.IOException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
            @RequestParam("title") String title,
            @RequestParam("text") String text,
            @RequestParam(value = "imageBase64Encrypted", required = false) String imageBase64Encrypted,
            @RequestParam(value = "encryptedFileName", required = false) String encryptedFileName,
            @RequestParam(value = "viewLimit", defaultValue = "0") int viewLimit,
            @RequestParam(value = "ttlMinutes", defaultValue = "0") int ttlMinutes
    ) throws IOException {
        Memo memo = memoService.createMemo(title, text, imageBase64Encrypted, encryptedFileName, viewLimit, ttlMinutes);
        return ResponseEntity.status(HttpStatus.CREATED).body(memo);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Memo> getMemo(@PathVariable("id") String id) throws IOException {
        Memo memo = memoService.getMemo(id);
        if (memo == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(memo);
    }

    @GetMapping("/list")
    public ResponseEntity<java.util.List<com.memo.app.entity.MemoList>> getMyMemos() {
        java.util.List<com.memo.app.entity.MemoList> memos = memoService.getMyMemos();
        return ResponseEntity.ok(memos);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteMemo(@PathVariable("id") String id) {
        try {
            memoService.deleteMemo(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}