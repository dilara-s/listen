package ru.kpfu.itis.music_service.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "chat_messages")
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private String username;

    @Column(nullable = false)
    private LocalDateTime timestamp;

//    // Дополнительные поля для музыкального контекста
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "shared_song_id")
//    private Song sharedSong;
//
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "shared_playlist_id")
//    private Playlist sharedPlaylist;
} 