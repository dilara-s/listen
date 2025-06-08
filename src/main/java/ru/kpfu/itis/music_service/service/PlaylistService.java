package ru.kpfu.itis.music_service.service;

import ru.kpfu.itis.music_service.dto.PlaylistDto;
import ru.kpfu.itis.music_service.entity.User;

import java.util.List;

public interface PlaylistService {
    PlaylistDto createPlaylist(User user, PlaylistDto playlistDto);
    PlaylistDto updatePlaylist(User user, Long id, PlaylistDto playlistDto);
    PlaylistDto getPlaylistById(Long id);
    List<PlaylistDto> getUserPlaylists(User user);
    void addSongToPlaylist(User user, Long playlistId, Long songId);
    void removeSongFromPlaylist(User user, Long playlistId, Long songId);
    void deletePlaylist(User user, Long id);
} 