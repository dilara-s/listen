package ru.kpfu.itis.music_service.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "artists")
public class Artist {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String biography;

    private String imageUrl;

    @ElementCollection
    @CollectionTable(name = "artist_tags", joinColumns = @JoinColumn(name = "artist_id"))
    @Column(name = "tag")
    private List<String> tags;

    @ElementCollection
    @CollectionTable(name = "artist_similar", joinColumns = @JoinColumn(name = "artist_id"))
    @Column(name = "similar_artist")
    private List<String> similarArtists;

    private String lastfmUrl;
} 