package ru.kpfu.itis.music_service.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import ru.kpfu.itis.music_service.dto.ChatMessageDto;
import ru.kpfu.itis.music_service.entity.User;
import ru.kpfu.itis.music_service.repository.UserRepository;
import ru.kpfu.itis.music_service.service.ChatMessageService;
import ru.kpfu.itis.music_service.service.UserService;

@Controller
@RequestMapping("/chat")
@RequiredArgsConstructor
public class ChatController {
    private final ChatMessageService chatMessageService;
    private final UserService userService;
    private final UserRepository userRepository;

    @GetMapping
    public String showChat(Model model, Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            User user = userRepository.findByUsername(authentication.getName())
                    .orElseThrow(() -> new RuntimeException("Пользователь не найден"));
            
            model.addAttribute("username", user.getUsername());
            return "chat/chat";
        }
        return "redirect:/login";
    }

    @MessageMapping("/send")
    public ChatMessageDto sendMessage(@Payload ChatMessageDto chatMessage, 
                                    SimpMessageHeaderAccessor headerAccessor) {
        User user = userService.getCurrentUser();
        chatMessage.setUsername(user.getUsername());
        return chatMessageService.saveMessage(chatMessage);
    }
} 