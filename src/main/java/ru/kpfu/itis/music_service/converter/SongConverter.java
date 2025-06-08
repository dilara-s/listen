package ru.kpfu.itis.music_service.converter;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import ru.kpfu.itis.music_service.config.AppConfig;
import ru.kpfu.itis.music_service.dto.SongDto;
import ru.kpfu.itis.music_service.entity.Song;
import ru.kpfu.itis.music_service.entity.User;
import ru.kpfu.itis.music_service.service.UserService;

@Component
@RequiredArgsConstructor
public class SongConverter implements EntityDtoConverter<Song, SongDto> {
    
    private final UserService userService;
    
    @Override
    public SongDto toDto(Song entity) {
        if (entity == null) {
            return null;
        }
        
        User currentUser = userService.getCurrentUser();
        boolean isFavorite = currentUser != null && 
                           currentUser.getFavoriteSongs().contains(entity);
        
        String coverUrl = entity.getCoverUrl();
        if (coverUrl == null || coverUrl.trim().isEmpty()) {
            coverUrl = AppConfig.DEFAULT_SONG_COVER_URL;
        }
        
        return SongDto.builder()
                .id(entity.getId())
                .title(entity.getTitle())
                .artistName(entity.getArtistName())
                .coverUrl(coverUrl)
                .audioUrl(entity.getAudioUrl())
                .favorite(isFavorite)
                .build();
    }
    
    @Override
    public Song toEntity(SongDto dto) {
        if (dto == null) {
            return null;
        }
        
        String coverUrl = dto.getCoverUrl();
        if (coverUrl == null || coverUrl.trim().isEmpty()) {
            coverUrl = AppConfig.DEFAULT_SONG_COVER_URL;
        }
        
        return Song.builder()
                .id(dto.getId())
                .title(dto.getTitle())
                .artistName(dto.getArtistName())
                .coverUrl(coverUrl)
                .audioUrl(dto.getAudioUrl())
                .build();
    }
} 