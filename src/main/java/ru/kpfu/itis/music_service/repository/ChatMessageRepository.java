package ru.kpfu.itis.music_service.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.kpfu.itis.music_service.entity.ChatMessage;

import java.util.List;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    @Query(value = "SELECT * FROM chat_messages ORDER BY timestamp DESC LIMIT :count", nativeQuery = true)
    List<ChatMessage> findTopNByOrderByTimestampDesc(@Param("count") int count);
    
    List<ChatMessage> findTop100ByOrderByTimestampDesc();
} 