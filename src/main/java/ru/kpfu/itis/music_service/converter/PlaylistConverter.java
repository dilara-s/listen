package ru.kpfu.itis.music_service.converter;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.music_service.config.AppConfig;
import ru.kpfu.itis.music_service.dto.PlaylistDto;
import ru.kpfu.itis.music_service.entity.Playlist;

import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class PlaylistConverter {
    
    private final SongConverter songConverter;
    
    public PlaylistDto toDto(Playlist entity) {
        if (entity == null) {
            return null;
        }
        
        String coverUrl = entity.getCoverUrl();
        if (coverUrl == null || coverUrl.trim().isEmpty()) {
            coverUrl = AppConfig.DEFAULT_PLAYLIST_COVER_URL;
        }
        
        return PlaylistDto.builder()
                .id(entity.getId())
                .title(entity.getTitle())
                .description(entity.getDescription())
                .coverUrl(coverUrl)
                .songs(entity.getSongs().stream()
                        .map(songConverter::toDto)
                        .collect(Collectors.toList()))
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }
    
    public Playlist toEntity(PlaylistDto dto) {
        if (dto == null) {
            return null;
        }
        
        String coverUrl = dto.getCoverUrl();
        if (coverUrl == null || coverUrl.trim().isEmpty()) {
            coverUrl = AppConfig.DEFAULT_PLAYLIST_COVER_URL;
        }
        
        return Playlist.builder()
                .id(dto.getId())
                .title(dto.getTitle())
                .description(dto.getDescription())
                .coverUrl(coverUrl)
                .songs(dto.getSongs().stream()
                        .map(songConverter::toEntity)
                        .collect(Collectors.toList()))
                .createdAt(dto.getCreatedAt())
                .updatedAt(dto.getUpdatedAt())
                .build();
    }
} 