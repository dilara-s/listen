package ru.kpfu.itis.music_service.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import ru.kpfu.itis.music_service.service.SongService;
import ru.kpfu.itis.music_service.service.PlaylistService;
import ru.kpfu.itis.music_service.service.UserService;

@Controller
@RequiredArgsConstructor
public class HomeController {

    private final SongService songService;
    private final PlaylistService playlistService;
    private final UserService userService;

    @GetMapping({"/", "/home"})
    @Transactional(readOnly = true)
    public String home(Model model, Authentication authentication) {
        // Если пользователь не аутентифицирован, перенаправляем на страницу входа
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        
        // Добавляем последние добавленные песни
        model.addAttribute("featuredSongs", songService.getAllSongs());
        
        // Добавляем данные пользователя
        model.addAttribute("user", userService.getCurrentUser());
        model.addAttribute("userPlaylists", 
            playlistService.getUserPlaylists(userService.getCurrentUser()));
        
        return "home";
    }
} 