package ru.kpfu.itis.music_service.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SongDto {
    private Long id;
    private String title;
    private String artistName;
    private String coverUrl;
    private String audioUrl;
    private boolean favorite;

    public boolean isFavorite() {
        return favorite;
    }
} 