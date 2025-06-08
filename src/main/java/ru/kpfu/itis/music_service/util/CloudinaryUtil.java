package ru.kpfu.itis.music_service.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Component
public class CloudinaryUtil {
    private static Cloudinary cloudinary;

    public static Cloudinary getInstance() {
        if (cloudinary == null) {
            Map<String, String> configMap = new HashMap<>();
            configMap.put("cloud_name", "dsyuw4byo");
            configMap.put("api_key", "167456931895523");
            configMap.put("api_secret", "ttTPMx_mpka-UJi_QrKh88hxDLU");
            cloudinary = new Cloudinary(configMap);
        }
        return cloudinary;
    }

    public String uploadFromUrl(String imageUrl, String publicId) throws IOException {
        Map<String, Object> options = ObjectUtils.asMap(
            "public_id", publicId,
            "overwrite", true,
            "resource_type", "image"
        );
        
        Map uploadResult = getInstance().uploader().upload(imageUrl, options);
        return uploadResult.get("secure_url").toString();
    }

    public String uploadFromFile(MultipartFile file, String publicId) throws IOException {
        Map<String, Object> options = ObjectUtils.asMap(
            "public_id", publicId,
            "overwrite", true,
            "resource_type", "auto"
        );
        
        Map uploadResult = getInstance().uploader().upload(file.getBytes(), options);
        return uploadResult.get("secure_url").toString();
    }
} 