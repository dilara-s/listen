package ru.kpfu.itis.music_service.converter;

import org.springframework.stereotype.Component;
import ru.kpfu.itis.music_service.dto.ArtistDto;
import ru.kpfu.itis.music_service.entity.Artist;

@Component
public class ArtistConverter implements EntityDtoConverter<Artist, ArtistDto> {
    
    @Override
    public ArtistDto toDto(Artist entity) {
        if (entity == null) {
            return null;
        }
        
        return ArtistDto.builder()
                .id(entity.getId())
                .name(entity.getName())
                .biography(entity.getBiography())
                .imageUrl(entity.getImageUrl())
                .tags(entity.getTags())
                .similarArtists(entity.getSimilarArtists())
                .lastfmUrl(entity.getLastfmUrl())
                .build();
    }
    
    @Override
    public Artist toEntity(ArtistDto dto) {
        if (dto == null) {
            return null;
        }
        
        return Artist.builder()
                .id(dto.getId())
                .name(dto.getName())
                .biography(dto.getBiography())
                .imageUrl(dto.getImageUrl())
                .tags(dto.getTags())
                .similarArtists(dto.getSimilarArtists())
                .lastfmUrl(dto.getLastfmUrl())
                .build();
    }
} 