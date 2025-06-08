package ru.kpfu.itis.music_service.handlers;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import ru.kpfu.itis.music_service.dto.ChatMessageDto;
import ru.kpfu.itis.music_service.service.ChatMessageService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {
    
    private static final Logger logger = LoggerFactory.getLogger(ChatWebSocketHandler.class);
    private final ObjectMapper objectMapper;
    private final ConcurrentHashMap<String, WebSocketSession> sessions = new ConcurrentHashMap<>();
    private final ChatMessageService chatMessageService;

    public ChatWebSocketHandler(ChatMessageService chatMessageService) {
        this.chatMessageService = chatMessageService;
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        this.objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String username = (String) session.getAttributes().get("username");
        sessions.put(username, session);

        try {
            // Отправляем историю сообщений новому пользователю
            List<ChatMessageDto> recentMessages = chatMessageService.getLastMessages(100);
            for (ChatMessageDto message : recentMessages) {
                sendMessageToSession(session, message);
                Thread.sleep(50); // Небольшая задержка между сообщениями
            }

            // Отправляем всем сообщение о подключении нового пользователя
            ChatMessageDto joinMessage = ChatMessageDto.builder()
                    .username(username)
                    .timestamp(LocalDateTime.now())
                    .content(username + " присоединился к чату")
                    .activeUsers(new ArrayList<>(sessions.keySet()))
                    .build();
            
            ChatMessageDto savedJoinMessage = chatMessageService.saveMessage(joinMessage);
            broadcastMessage(savedJoinMessage);
        } catch (Exception e) {
            logger.error("Ошибка при инициализации подключения для пользователя {}: {}", username, e.getMessage());
            session.close(CloseStatus.SERVER_ERROR);
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage textMessage) throws Exception {
        try {
            String payload = textMessage.getPayload();
            ChatMessageDto message = objectMapper.readValue(payload, ChatMessageDto.class);
            message.setTimestamp(LocalDateTime.now());
            
            String username = (String) session.getAttributes().get("username");
            message.setUsername(username);
            message.setActiveUsers(new ArrayList<>(sessions.keySet()));
            
            ChatMessageDto savedMessage = chatMessageService.saveMessage(message);
            broadcastMessage(savedMessage);
        } catch (Exception e) {
            logger.error("Ошибка при обработке сообщения: {}", e.getMessage());
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        String username = (String) session.getAttributes().get("username");
        sessions.remove(username);

        try {
            ChatMessageDto message = ChatMessageDto.builder()
                    .username(username)
                    .timestamp(LocalDateTime.now())
                    .content(username + " покинул чат")
                    .activeUsers(new ArrayList<>(sessions.keySet()))
                    .build();
            
            ChatMessageDto savedMessage = chatMessageService.saveMessage(message);
            broadcastMessage(savedMessage);
        } catch (Exception e) {
            logger.error("Ошибка при закрытии соединения для пользователя {}: {}", username, e.getMessage());
        }
    }

    private void sendMessageToSession(WebSocketSession session, ChatMessageDto message) throws IOException {
        if (session.isOpen()) {
            String messageJson = objectMapper.writeValueAsString(message);
            synchronized (session) {
                session.sendMessage(new TextMessage(messageJson));
            }
        }
    }

    private void broadcastMessage(ChatMessageDto message) {
        String messageJson;
        try {
            messageJson = objectMapper.writeValueAsString(message);
            TextMessage textMessage = new TextMessage(messageJson);

            for (WebSocketSession userSession : sessions.values()) {
                if (userSession.isOpen()) {
                    synchronized (userSession) {
                        userSession.sendMessage(textMessage);
                    }
                }
            }
        } catch (IOException e) {
            logger.error("Ошибка при отправке сообщения: {}", e.getMessage());
        }
    }
}

/*package ru.kpfu.itis.music_service.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import ru.kpfu.itis.music_service.dto.ChatMessageDto;
import ru.kpfu.itis.music_service.service.ChatMessageService;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
@RequiredArgsConstructor
public class ChatWebSocketHandler extends TextWebSocketHandler {
    private final ChatMessageService chatMessageService;
    private final ObjectMapper objectMapper;
    private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        String username = (String) session.getAttributes().get("username");
        sessions.put(username, session);

        // Отправляем последние сообщения пользователю
        try {
            for (ChatMessageDto message : chatMessageService.getLastMessages(10)) {
                session.sendMessage(new TextMessage(objectMapper.writeValueAsString(message)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String username = (String) session.getAttributes().get("username");
        ChatMessageDto chatMessage = objectMapper.readValue(message.getPayload(), ChatMessageDto.class);
        chatMessage.setSender(username);

        // Сохраняем сообщение
        chatMessageService.saveMessage(chatMessage);

        // Отправляем сообщение всем подключенным пользователям
        TextMessage outMessage = new TextMessage(objectMapper.writeValueAsString(chatMessage));
        for (WebSocketSession clientSession : sessions.values()) {
            if (clientSession.isOpen()) {
                clientSession.sendMessage(outMessage);
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        String username = (String) session.getAttributes().get("username");
        sessions.remove(username);
    }
} */