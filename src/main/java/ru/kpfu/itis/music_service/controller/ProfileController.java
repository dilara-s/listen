package ru.kpfu.itis.music_service.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.music_service.dto.UserDto;
import ru.kpfu.itis.music_service.entity.User;
import ru.kpfu.itis.music_service.service.PlaylistService;
import ru.kpfu.itis.music_service.service.SongService;
import ru.kpfu.itis.music_service.service.UserService;
import ru.kpfu.itis.music_service.util.CloudinaryUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/profile")
@RequiredArgsConstructor
public class ProfileController {
    private final UserService userService;
    private final PlaylistService playlistService;
    private final SongService songService;

    @GetMapping
    public String getCurrentUserProfile(Model model) {
        User currentUser = userService.getCurrentUser();
        model.addAttribute("user", userService.findById(currentUser.getId()));
        model.addAttribute("playlists", playlistService.getUserPlaylists(currentUser));
        model.addAttribute("favoriteSongs", songService.getFavoriteSongs(currentUser));
        return "profile/view";
    }

    @GetMapping("/{id}")
    public String getUserProfile(@PathVariable Long id, Model model) {
        // Получаем текущего пользователя для проверки прав доступа в шаблоне
        User currentUser = userService.getCurrentUser();
        UserDto userDto = userService.findById(id);
        
        model.addAttribute("user", userDto);
        model.addAttribute("playlists", playlistService.getUserPlaylists(currentUser));
        model.addAttribute("favoriteSongs", songService.getFavoriteSongs(currentUser));
        return "profile/view";
    }

    @GetMapping("/edit")
    public String editProfile(Model model) {
        User currentUser = userService.getCurrentUser();
        UserDto userDto = userService.findById(currentUser.getId());
        model.addAttribute("user", userDto);
        model.addAttribute("userDto", userDto);
        return "profile/edit";
    }

    @PostMapping("/edit")
    public String updateProfile(
            @ModelAttribute UserDto userDto,
            @RequestParam(value = "avatar", required = false) MultipartFile avatar) throws IOException {
        User currentUser = userService.getCurrentUser();
        
        // Если загружен новый аватар, загружаем его в Cloudinary
        if (avatar != null && !avatar.isEmpty()) {
            Map<String, Object> params = new HashMap<>();
            params.put("folder", "avatars");
            
            Map result = CloudinaryUtil.getInstance().uploader().upload(avatar.getBytes(), params);
            String avatarUrl = (String) result.get("secure_url");
            userDto.setAvatarUrl(avatarUrl);
        }
        
        userService.update(currentUser.getId(), userDto);
        return "redirect:/profile";
    }

    @GetMapping("/{id}/playlists")
    public String getUserPlaylists(@PathVariable Long id, Model model) {
        // Получаем текущего пользователя для проверки прав доступа в шаблоне
        User currentUser = userService.getCurrentUser();
        UserDto userDto = userService.findById(id);
        
        model.addAttribute("user", userDto);
        model.addAttribute("playlists", playlistService.getUserPlaylists(currentUser));
        return "profile/playlists";
    }

    @PostMapping("/delete")
    public String deleteAccount() {
        User currentUser = userService.getCurrentUser();
        userService.delete(currentUser.getId());
        return "redirect:/logout";
    }

    @GetMapping("/{id}/favorites")
    public String getUserFavorites(@PathVariable Long id, Model model) {
        // Получаем текущего пользователя для проверки прав доступа в шаблоне
        User currentUser = userService.getCurrentUser();
        User profileUser = userService.getUserById(id);
        UserDto userDto = userService.findById(id);
        
        model.addAttribute("user", userDto);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("songs", songService.getFavoriteSongs(profileUser));
        return "profile/favorites";
    }
} 