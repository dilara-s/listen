package ru.kpfu.itis.music_service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.music_service.dto.PlaylistDto;
import ru.kpfu.itis.music_service.service.PlaylistService;
import ru.kpfu.itis.music_service.service.UserService;

import java.util.List;

@RestController
@RequestMapping("/api/playlists")
@RequiredArgsConstructor
@Tag(name = "Playlist API", description = "API для работы с плейлистами")
public class PlaylistRestController {

    private final PlaylistService playlistService;
    private final UserService userService;

    @PostMapping
    @Operation(summary = "Создать новый плейлист")
    public ResponseEntity<PlaylistDto> createPlaylist(@RequestBody PlaylistDto playlistDto) {
        return ResponseEntity.ok(playlistService.createPlaylist(userService.getCurrentUser(), playlistDto));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Обновить плейлист")
    public ResponseEntity<PlaylistDto> updatePlaylist(
            @PathVariable Long id,
            @RequestBody PlaylistDto playlistDto) {
        return ResponseEntity.ok(playlistService.updatePlaylist(userService.getCurrentUser(), id, playlistDto));
    }

    @GetMapping
    @Operation(summary = "Получить все плейлисты пользователя")
    public ResponseEntity<List<PlaylistDto>> getUserPlaylists() {
        return ResponseEntity.ok(playlistService.getUserPlaylists(userService.getCurrentUser()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Получить плейлист по ID")
    public ResponseEntity<PlaylistDto> getPlaylist(@PathVariable Long id) {
        return ResponseEntity.ok(playlistService.getPlaylistById(id));
    }

    @PostMapping("/{playlistId}/songs/{songId}")
    @Operation(summary = "Добавить песню в плейлист")
    public ResponseEntity<Void> addSongToPlaylist(
            @PathVariable Long playlistId,
            @PathVariable Long songId) {
        playlistService.addSongToPlaylist(userService.getCurrentUser(), playlistId, songId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{playlistId}/songs/{songId}")
    @Operation(summary = "Удалить песню из плейлиста")
    public ResponseEntity<Void> removeSongFromPlaylist(
            @PathVariable Long playlistId,
            @PathVariable Long songId) {
        playlistService.removeSongFromPlaylist(userService.getCurrentUser(), playlistId, songId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Удалить плейлист")
    public ResponseEntity<Void> deletePlaylist(@PathVariable Long id) {
        playlistService.deletePlaylist(userService.getCurrentUser(), id);
        return ResponseEntity.ok().build();
    }
} 