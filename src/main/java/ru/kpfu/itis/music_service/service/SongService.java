package ru.kpfu.itis.music_service.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.music_service.converter.SongConverter;
import ru.kpfu.itis.music_service.dto.SongDto;
import ru.kpfu.itis.music_service.entity.Song;
import ru.kpfu.itis.music_service.entity.User;
import ru.kpfu.itis.music_service.repository.SongRepository;
import ru.kpfu.itis.music_service.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import ru.kpfu.itis.music_service.config.AppConfig;
import ru.kpfu.itis.music_service.exception.ResourceNotFoundException;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SongService {
    private final SongRepository songRepository;
    private final UserRepository userRepository;
    private final SongConverter songConverter;

    @Autowired
    private UserService userService;

    public List<SongDto> getAllSongs() {
        return songRepository.findAll().stream()
                .map(songConverter::toDto)
                .collect(Collectors.toList());
    }

    public SongDto getSongById(Long id) {
        return songRepository.findById(id)
                .map(songConverter::toDto)
                .orElseThrow(() -> new RuntimeException("Song not found"));
    }

    public List<SongDto> searchByTitle(String query) {
        return songRepository.findByTitleContainingIgnoreCase(query).stream()
                .map(songConverter::toDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public void addToFavorites(User user, Long songId) {
        Song song = songRepository.findById(songId)
                .orElseThrow(() -> new RuntimeException("Song not found"));
        if (!user.hasFavorite(song)) {
            user.addToFavorites(song);
            userRepository.save(user);
        }
    }

    @Transactional
    public void removeFromFavorites(User user, Long songId) {
        Song song = songRepository.findById(songId)
                .orElseThrow(() -> new RuntimeException("Song not found"));
        if (user.hasFavorite(song)) {
            user.removeFromFavorites(song);
            userRepository.save(user);
        }
    }

    public List<SongDto> getFavoriteSongs(User user) {
        return user.getFavoriteSongs().stream()
                .map(songConverter::toDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public SongDto createSong(SongDto songDto) {
        Song song = songConverter.toEntity(songDto);
        song.setCoverUrl(songDto.getCoverUrl() != null ? songDto.getCoverUrl() : AppConfig.DEFAULT_SONG_COVER_URL);
        Song savedSong = songRepository.save(song);
        return songConverter.toDto(savedSong);
    }

    @Transactional
    public void deleteSong(Long id) {
        songRepository.deleteById(id);
    }

    public Song createSong(String title, String artistName, String audioUrl, String coverUrl) {
        Song song = new Song();
        song.setTitle(title);
        song.setArtistName(artistName);
        song.setAudioUrl(audioUrl);
        song.setCoverUrl(coverUrl != null ? coverUrl : AppConfig.DEFAULT_SONG_COVER_URL);
        return songRepository.save(song);
    }

    public Song updateSong(Long id, String title, String artistName, String audioUrl, String coverUrl) {
        Song song = songRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Song not found"));
        song.setTitle(title);
        song.setArtistName(artistName);
        if (audioUrl != null) {
            song.setAudioUrl(audioUrl);
        }
        if (coverUrl != null) {
            song.setCoverUrl(coverUrl);
        } else {
            song.setCoverUrl(AppConfig.DEFAULT_SONG_COVER_URL);
        }
        return songRepository.save(song);
    }
} 