package ru.kpfu.itis.music_service.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ru.kpfu.itis.music_service.entity.User;
import ru.kpfu.itis.music_service.service.SongService;
import ru.kpfu.itis.music_service.service.UserService;

@Controller
@RequestMapping("/songs")
@RequiredArgsConstructor
public class SongController {
    private final SongService songService;
    private final UserService userService;

    @GetMapping
    public String listSongs(
            @RequestParam(required = false) String query,
            Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        User currentUser = userService.getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (query != null && !query.trim().isEmpty()) {
            model.addAttribute("songs", songService.searchByTitle(query));
            model.addAttribute("query", query);
        } else {
            model.addAttribute("songs", songService.getAllSongs());
        }
        
        model.addAttribute("currentUser", currentUser);
        return "songs/list";
    }

    @GetMapping("/upload")
    @PreAuthorize("hasRole('ADMIN')")
    public String showUploadForm(Model model) {
        User currentUser = userService.getCurrentUser();
        model.addAttribute("currentUser", currentUser);
        return "songs/upload";
    }
}