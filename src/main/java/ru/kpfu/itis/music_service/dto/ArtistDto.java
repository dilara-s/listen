package ru.kpfu.itis.music_service.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ArtistDto {
    private Long id;
    private String name;
    private String biography;
    private String imageUrl;
    private List<String> tags;
    private List<String> similarArtists;
    private String lastfmUrl;
} 