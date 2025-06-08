package ru.kpfu.itis.music_service.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlaylistDto {
    private Long id;
    private String title;
    private String description;
    private String coverUrl;
    private UserDto owner;
    private List<SongDto> songs = new ArrayList<>();
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
} 