package ru.kpfu.itis.music_service.controller;

import com.cloudinary.Cloudinary;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.music_service.config.AppConfig;
import ru.kpfu.itis.music_service.util.CloudinaryUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/users/files")
@RequiredArgsConstructor
public class UserFileController {
    
    @PostMapping("/avatar")
    public ResponseEntity<String> uploadAvatar(@RequestParam("file") MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            return ResponseEntity.ok(AppConfig.DEFAULT_USER_AVATAR_URL);
        }

        Cloudinary cloudinary = CloudinaryUtil.getInstance();
        Map<String, Object> params = new HashMap<>();
        params.put("folder", "users/avatars");
        params.put("transformation", Map.of(
            "width", 400,
            "height", 400,
            "crop", "fill",
            "gravity", "face"
        ));
        
        Map result = cloudinary.uploader().upload(file.getBytes(), params);
        String avatarUrl = (String) result.get("secure_url");
        
        return ResponseEntity.ok(avatarUrl);
    }
} 