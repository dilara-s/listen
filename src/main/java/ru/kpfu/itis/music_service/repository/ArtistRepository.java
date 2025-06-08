package ru.kpfu.itis.music_service.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ru.kpfu.itis.music_service.entity.Artist;

import java.util.List;
import java.util.Optional;

public interface ArtistRepository extends JpaRepository<Artist, Long> {
    Optional<Artist> findByName(String name);
    
    // Нестандартный метод: поиск артистов по частичному совпадению имени
    @Query("SELECT a FROM Artist a WHERE LOWER(a.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Artist> findByNameContainingIgnoreCase(String name);
    
    @Query("SELECT a FROM Artist a ORDER BY SIZE(a.tags) DESC")
    List<Artist> findAllOrderByTagsSizeDesc();
    
    @Query(value = """
        SELECT a.* FROM artists a 
        LEFT JOIN (
            SELECT artist_id, COUNT(*) as tag_count 
            FROM artist_tags 
            GROUP BY artist_id
        ) t ON a.id = t.artist_id 
        ORDER BY t.tag_count DESC NULLS LAST 
        LIMIT 10
        """, nativeQuery = true)
    List<Artist> findTop10ByOrderByTagsSizeDesc();
    
    List<Artist> findByTagsContaining(String tag);
} 