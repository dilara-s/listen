package ru.kpfu.itis.music_service.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ru.kpfu.itis.music_service.entity.Playlist;
import ru.kpfu.itis.music_service.entity.User;

import java.util.List;

public interface PlaylistRepository extends JpaRepository<Playlist, Long> {
    List<Playlist> findByOwner(User owner);
    
    // Поиск плейлистов по частичному совпадению названия
    List<Playlist> findByTitleContainingIgnoreCase(String title);
    
    // Нестандартный метод: поиск плейлистов с определенным количеством песен
    @Query("SELECT p FROM Playlist p WHERE SIZE(p.songs) >= :minSongs")
    List<Playlist> findPlaylistsWithMinSongs(int minSongs);
    
    // Нестандартный метод: поиск плейлистов, содержащих определенную песню
    @Query("SELECT p FROM Playlist p JOIN p.songs s WHERE s.id = :songId")
    List<Playlist> findPlaylistsContainingSong(Long songId);
} 