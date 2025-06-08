package ru.kpfu.itis.music_service.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ru.kpfu.itis.music_service.dto.UserRegistrationDto;
import ru.kpfu.itis.music_service.service.UserService;

@Controller
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;
    private final AuthenticationManager authenticationManager;

    @GetMapping("/registration")
    public String showRegistrationForm(Model model) {
        model.addAttribute("userRegistrationDto", new UserRegistrationDto());
        return "auth/register";
    }

    @PostMapping("/registration")
    public String registerUser(@Valid UserRegistrationDto userDto, 
                             BindingResult result, 
                             Model model) {
        if (result.hasErrors()) {
            return "auth/register";
        }
        
        try {
            userService.register(userDto);
            return "redirect:/login?registered=true";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "auth/register";
        }
    }

    @GetMapping("/login")
    public String login(Model model, 
                       @RequestParam(value = "error", required = false) String error,
                       @RequestParam(value = "registered", required = false) Boolean registered) {
        if (error != null) {
            model.addAttribute("error", "Неверное имя пользователя или пароль");
        }
        
        if (registered != null && registered) {
            model.addAttribute("message", "Регистрация успешна! Теперь вы можете войти.");
        }
        
        return "auth/login";
    }

    @GetMapping("/activation")
    public String activation() {
        return "auth/activation-success";
    }

    @GetMapping("/confirmation-send")
    public String confirmationSend() {
        return "auth/confirmation-send";
    }
} 