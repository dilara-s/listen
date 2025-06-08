package ru.kpfu.itis.music_service.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.kpfu.itis.music_service.dto.PlaylistDto;
import ru.kpfu.itis.music_service.service.PlaylistService;
import ru.kpfu.itis.music_service.service.SongService;
import ru.kpfu.itis.music_service.service.UserService;
import ru.kpfu.itis.music_service.util.CloudinaryUtil;

import java.io.IOException;
import java.util.Arrays;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/playlists")
@RequiredArgsConstructor
public class PlaylistController {
    private final PlaylistService playlistService;
    private final UserService userService;
    private final SongService songService;
    private final CloudinaryUtil cloudinaryUtil;

    @GetMapping
    public String listPlaylists(Model model) {
        model.addAttribute("playlists", playlistService.getUserPlaylists(userService.getCurrentUser()));
        return "playlists/list";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("playlistDto", new PlaylistDto());
        model.addAttribute("songs", songService.getAllSongs());
        return "playlists/create";
    }

    @PostMapping("/create")
    public String createPlaylist(
            @ModelAttribute PlaylistDto playlistDto,
            @RequestParam(required = false) String selectedSongs,
            @RequestParam(value = "cover", required = false) MultipartFile cover) throws IOException {
        
        // Upload cover if provided
        if (cover != null && !cover.isEmpty()) {
            String coverUrl = cloudinaryUtil.uploadFromFile(cover, "playlists/" + playlistDto.getTitle());
            playlistDto.setCoverUrl(coverUrl);
        }
        
        PlaylistDto created = playlistService.createPlaylist(userService.getCurrentUser(), playlistDto);
        
        // Add selected songs to the playlist
        if (selectedSongs != null && !selectedSongs.isEmpty()) {
            Arrays.stream(selectedSongs.split(","))
                    .map(Long::parseLong)
                    .forEach(songId -> playlistService.addSongToPlaylist(userService.getCurrentUser(), created.getId(), songId));
        }
        
        return "redirect:/playlists/" + created.getId();
    }

    @GetMapping("/{id}")
    public String viewPlaylist(
            @PathVariable Long id,
            Model model) {
        model.addAttribute("playlist", playlistService.getPlaylistById(id));
        return "playlists/view";
    }

    @GetMapping("/{id}/edit")
    public String editPlaylist(
            @PathVariable Long id,
            Model model) {
        model.addAttribute("playlist", playlistService.getPlaylistById(id));
        model.addAttribute("songs", songService.getAllSongs());
        return "playlists/edit";
    }

    @PostMapping("/{id}/update")
    public String updatePlaylist(
            @PathVariable Long id,
            @ModelAttribute PlaylistDto playlistDto,
            @RequestParam(value = "cover", required = false) MultipartFile cover) throws IOException {
        
        // Upload cover if provided
        if (cover != null && !cover.isEmpty()) {
            String coverUrl = cloudinaryUtil.uploadFromFile(cover, "playlists/" + playlistDto.getTitle());
            playlistDto.setCoverUrl(coverUrl);
        }
        
        playlistService.updatePlaylist(userService.getCurrentUser(), id, playlistDto);
        return "redirect:/playlists/" + id;
    }

    @PostMapping("/{id}/delete")
    public String deletePlaylist(
            @PathVariable Long id) {
        playlistService.deletePlaylist(userService.getCurrentUser(), id);
        return "redirect:/profile/" + userService.getCurrentUser().getId() + "/playlists";
    }
} 