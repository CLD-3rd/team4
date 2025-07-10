package com.memo.app.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;

import java.io.IOException;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class S3Service {

    private final S3Client s3Client;
    private final String bucketName = "kaijutestbucket";
//    private final String bucketName = "1dyntestbucket";

    // 이미지 업로드
    public String upload(MultipartFile file) throws IOException {
        String originalFilename = file.getOriginalFilename();
        String key = "images/" + UUID.randomUUID() + "_" + originalFilename;

        PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .contentType(file.getContentType())
                .build();

        s3Client.putObject(
                putObjectRequest,
                software.amazon.awssdk.core.sync.RequestBody.fromInputStream(
                        file.getInputStream(), file.getSize()
                )
        );

        // 업로드한 S3 객체의 URL 반환
        return s3Client.utilities()
                .getUrl(builder -> builder.bucket(bucketName).key(key))
                .toExternalForm();
    }

    // 이미지 삭제
    public void delete(String imageUrl) {
        try {
            String key = extractKeyFromUrl(imageUrl);
            
            // url 검증
            if (key == null) {
                System.err.println("❌ 삭제 실패 - 유효하지 않은 S3 URL: " + imageUrl);
                return;
            }
            
            DeleteObjectRequest deleteRequest = DeleteObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            s3Client.deleteObject(deleteRequest);
            System.out.println("S3 이미지 삭제 완료: " + key);

        } catch (Exception e) {
            System.err.println("S3 이미지 삭제 실패: " + imageUrl);
            e.printStackTrace();
        }
    }

    // S3 URL에서 키 추출
    private String extractKeyFromUrl(String url) {
        return url.substring(url.indexOf("images/"));
    }
}
