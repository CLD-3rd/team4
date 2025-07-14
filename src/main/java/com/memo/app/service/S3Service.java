package com.memo.app.service;

import java.io.IOException;
import java.util.Base64;
import java.util.UUID;

import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

@Component
@RequiredArgsConstructor
public class S3Service {

    private final S3Client s3Client;
    private final String bucketName = "kaijutestbucket";
//    private final String bucketName = "1dyntestbucket";

    // 이미지 업로드
    public String upload(String encryptedBase64) throws IOException {
    	byte[] bytes = Base64.getDecoder().decode(encryptedBase64);
        String key = "images/" + UUID.randomUUID();

        PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .contentType("application/octet-stream")
                .build();

        s3Client.putObject(
                putObjectRequest,
                software.amazon.awssdk.core.sync.RequestBody.fromBytes(bytes)
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
    public String extractKeyFromUrl(String url) {
        if (url == null || !url.contains("images/")) {
            return null;
        }
        return url.substring(url.indexOf("images/"));
    }

    // 파일 다운로드
    public byte[] downloadFile(String key) throws IOException {
        GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .build();
        return s3Client.getObjectAsBytes(getObjectRequest).asByteArray();
    }
}
