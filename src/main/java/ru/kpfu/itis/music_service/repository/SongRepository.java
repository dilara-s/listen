package ru.kpfu.itis.music_service.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ru.kpfu.itis.music_service.entity.Song;

import java.util.List;

public interface SongRepository extends JpaRepository<Song, Long> {
    List<Song> findByArtistName(String artistName);
    List<Song> findByTitleContainingIgnoreCase(String title);
    
    // Поиск по названию песни и имени артиста
    @Query("SELECT s FROM Song s WHERE " +
           "LOWER(s.title) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(s.artistName) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Song> searchByTitleOrArtistName(String query);

    List<Song> findByArtistNameOrderByTitleAsc(String artistName);
    List<Song> findTop10ByOrderByIdDesc();
} 