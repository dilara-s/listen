package ru.kpfu.itis.music_service.controller;

import com.cloudinary.Cloudinary;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.music_service.util.CloudinaryUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/songs/files")
@RequiredArgsConstructor
public class SongFileController {

    @PostMapping("/audio")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> uploadAudio(@RequestParam("file") MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("Audio file is required");
        }

        Cloudinary cloudinary = CloudinaryUtil.getInstance();
        Map<String, Object> params = new HashMap<>();
        params.put("resource_type", "auto");
        params.put("folder", "songs/audio");
        
        Map result = cloudinary.uploader().upload(file.getBytes(), params);
        String audioUrl = (String) result.get("secure_url");
        
        return ResponseEntity.ok(audioUrl);
    }

    @PostMapping("/cover")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> uploadCover(@RequestParam("file") MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("Cover image is required");
        }

        Cloudinary cloudinary = CloudinaryUtil.getInstance();
        Map<String, Object> params = new HashMap<>();
        params.put("folder", "songs/covers");
        
        Map result = cloudinary.uploader().upload(file.getBytes(), params);
        String coverUrl = (String) result.get("secure_url");
        
        return ResponseEntity.ok(coverUrl);
    }
} 