package ru.kpfu.itis.music_service.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.music_service.dto.PlaylistDto;
import ru.kpfu.itis.music_service.entity.Playlist;
import ru.kpfu.itis.music_service.entity.Song;
import ru.kpfu.itis.music_service.entity.User;
import ru.kpfu.itis.music_service.repository.PlaylistRepository;
import ru.kpfu.itis.music_service.repository.SongRepository;
import ru.kpfu.itis.music_service.service.PlaylistService;
import ru.kpfu.itis.music_service.converter.PlaylistConverter;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PlaylistServiceImpl implements PlaylistService {

    private final PlaylistRepository playlistRepository;
    private final SongRepository songRepository;
    private final PlaylistConverter playlistConverter;

    @Override
    @Transactional
    public PlaylistDto createPlaylist(User user, PlaylistDto playlistDto) {
        Playlist playlist = playlistConverter.toEntity(playlistDto);
        playlist.setOwner(user);
        return playlistConverter.toDto(playlistRepository.save(playlist));
    }

    @Override
    @Transactional
    public PlaylistDto updatePlaylist(User user, Long id, PlaylistDto playlistDto) {
        Playlist playlist = getPlaylistAndCheckAccess(user, id);
        
        playlist.setTitle(playlistDto.getTitle());
        playlist.setDescription(playlistDto.getDescription());
        if (playlistDto.getCoverUrl() != null) {
            playlist.setCoverUrl(playlistDto.getCoverUrl());
        }
        
        return playlistConverter.toDto(playlistRepository.save(playlist));
    }

    @Override
    public PlaylistDto getPlaylistById(Long id) {
        return playlistRepository.findById(id)
                .map(playlistConverter::toDto)
                .orElseThrow(() -> new RuntimeException("Playlist not found"));
    }

    @Override
    @Transactional(readOnly = true)
    public List<PlaylistDto> getUserPlaylists(User user) {
        return playlistRepository.findByOwner(user).stream()
                .map(playlistConverter::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void addSongToPlaylist(User user, Long playlistId, Long songId) {
        Playlist playlist = getPlaylistAndCheckAccess(user, playlistId);
        Song song = songRepository.findById(songId)
                .orElseThrow(() -> new RuntimeException("Song not found"));
        
        playlist.getSongs().add(song);
        playlistRepository.save(playlist);
    }

    @Override
    @Transactional
    public void removeSongFromPlaylist(User user, Long playlistId, Long songId) {
        Playlist playlist = getPlaylistAndCheckAccess(user, playlistId);
        playlist.getSongs().removeIf(song -> song.getId().equals(songId));
        playlistRepository.save(playlist);
    }

    @Override
    @Transactional
    public void deletePlaylist(User user, Long id) {
        Playlist playlist = getPlaylistAndCheckAccess(user, id);
        playlistRepository.delete(playlist);
    }

    private Playlist getPlaylistAndCheckAccess(User user, Long playlistId) {
        Playlist playlist = playlistRepository.findById(playlistId)
                .orElseThrow(() -> new RuntimeException("Playlist not found"));
        
        if (!playlist.getOwner().getId().equals(user.getId())) {
            throw new RuntimeException("Access denied");
        }
        
        return playlist;
    }
} 