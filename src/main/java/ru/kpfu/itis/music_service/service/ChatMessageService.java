package ru.kpfu.itis.music_service.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.music_service.dto.ChatMessageDto;
import ru.kpfu.itis.music_service.entity.ChatMessage;
import ru.kpfu.itis.music_service.repository.ChatMessageRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ChatMessageService {
    
    private final ChatMessageRepository chatMessageRepository;

    public ChatMessageDto saveMessage(ChatMessageDto messageDto) {
        ChatMessage message = ChatMessage.builder()
                .content(messageDto.getContent())
                .username(messageDto.getUsername())
                .timestamp(messageDto.getTimestamp())
                .build();
        
        ChatMessage savedMessage = chatMessageRepository.save(message);
        return convertToDto(savedMessage);
    }

    public List<ChatMessageDto> getLastMessages(int count) {
        return chatMessageRepository.findTopNByOrderByTimestampDesc(count)
                .stream()
                .map(this::convertToDto)
                .sorted((m1, m2) -> m1.getTimestamp().compareTo(m2.getTimestamp()))
                .collect(Collectors.toList());
    }

    private ChatMessageDto convertToDto(ChatMessage message) {
        return ChatMessageDto.builder()
                .content(message.getContent())
                .username(message.getUsername())
                .timestamp(message.getTimestamp())
                .build();
    }
} 