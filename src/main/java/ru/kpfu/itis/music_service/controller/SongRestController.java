package ru.kpfu.itis.music_service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.music_service.dto.SongDto;
import ru.kpfu.itis.music_service.entity.User;
import ru.kpfu.itis.music_service.service.SongService;
import ru.kpfu.itis.music_service.service.UserService;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/songs")
@RequiredArgsConstructor
@Tag(name = "Song API", description = "API для работы с песнями")
public class SongRestController {
    private final SongService songService;
    private final UserService userService;

    @GetMapping
    @Operation(summary = "Получить все песни")
    public ResponseEntity<List<SongDto>> getAllSongs() {
        return ResponseEntity.ok(songService.getAllSongs());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Получить песню по ID")
    public ResponseEntity<SongDto> getSong(@PathVariable Long id) {
        return ResponseEntity.ok(songService.getSongById(id));
    }

    @GetMapping("/search")
    @Operation(summary = "Поиск песен по названию")
    public ResponseEntity<List<SongDto>> searchSongs(@RequestParam String query) {
        return ResponseEntity.ok(songService.searchByTitle(query));
    }

    @GetMapping("/user/favorites")
    @Operation(summary = "Получить список любимых песен пользователя")
    public ResponseEntity<List<SongDto>> getFavoriteSongs() {
        return ResponseEntity.ok(songService.getFavoriteSongs(userService.getCurrentUser()));
    }

    @PostMapping("/{songId}/favorite")
    @Operation(summary = "Добавить песню в любимые")
    public ResponseEntity<Void> addToFavorites(@PathVariable Long songId) {
        User currentUser = userService.getCurrentUser();
        log.info("Adding song {} to favorites for user {}", songId, currentUser.getUsername());
        songService.addToFavorites(currentUser, songId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{songId}/favorite")
    @Operation(summary = "Удалить песню из любимых")
    public ResponseEntity<Void> removeFromFavorites(@PathVariable Long songId) {
        User currentUser = userService.getCurrentUser();
        log.info("Removing song {} from favorites for user {}", songId, currentUser.getUsername());
        songService.removeFromFavorites(currentUser, songId);
        return ResponseEntity.ok().build();
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Создать новую песню (только для админов)")
    public ResponseEntity<SongDto> createSong(@RequestBody SongDto songDto) {
        return ResponseEntity.ok(songService.createSong(songDto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Удалить песню (только для админов)")
    public ResponseEntity<Void> deleteSong(@PathVariable Long id) {
        songService.deleteSong(id);
        return ResponseEntity.ok().build();
    }
} 