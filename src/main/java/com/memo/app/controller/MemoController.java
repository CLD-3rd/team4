package com.memo.app.controller;

import com.memo.app.dto.Memo;
import com.memo.app.service.MemoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("/memos")
public class MemoController {

    private final MemoService memoService;

    public MemoController(MemoService memoService) {
        this.memoService = memoService;
    }

    @PostMapping
    public ResponseEntity<Memo> createMemo(@RequestParam("text") String text) throws IOException {
        Memo memo = memoService.createMemo(text);
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
