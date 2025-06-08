package ru.kpfu.itis.music_service.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.kpfu.itis.music_service.dto.UserDto;
import ru.kpfu.itis.music_service.dto.UserRegistrationDto;
import ru.kpfu.itis.music_service.entity.Role;
import ru.kpfu.itis.music_service.entity.User;
import ru.kpfu.itis.music_service.repository.UserRepository;
import ru.kpfu.itis.music_service.service.UserService;
import ru.kpfu.itis.music_service.util.CloudinaryUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public UserDto register(UserRegistrationDto registrationDto) {
        // Проверяем, что пользователь с таким email или username не существует
        if (userRepository.existsByEmail(registrationDto.getEmail())) {
            throw new RuntimeException("Email already exists");
        }
        if (userRepository.existsByUsername(registrationDto.getUsername())) {
            throw new RuntimeException("Username already exists");
        }

        User user = User.builder()
                .username(registrationDto.getUsername())
                .email(registrationDto.getEmail())
                .password(passwordEncoder.encode(registrationDto.getPassword()))
                .role(Role.USER)
                .build();

        // Проверяем админский код
        if (registrationDto.getAdminCode() != null && registrationDto.getAdminCode().equals("12345")) {
            user.setRole(Role.ADMIN);
        }

        // Загружаем аватар, если он есть
        if (registrationDto.getAvatar() != null && !registrationDto.getAvatar().isEmpty()) {
            try {
                Map<String, Object> params = new HashMap<>();
                params.put("folder", "users/avatars");
                params.put("transformation", Map.of(
                    "width", 400,
                    "height", 400,
                    "crop", "fill",
                    "gravity", "face"
                ));
                Map result = CloudinaryUtil.getInstance().uploader().upload(registrationDto.getAvatar().getBytes(), params);
                user.setAvatarUrl((String) result.get("secure_url"));
            } catch (IOException e) {
                throw new RuntimeException("Failed to upload avatar", e);
            }
        }

        return convertToDto(userRepository.save(user));
    }

    @Override
    public UserDto findById(Long id) {
        return userRepository.findById(id)
                .map(this::convertToDto)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Override
    public UserDto findByUsername(String username) {
        return userRepository.findByUsername(username)
                .map(this::convertToDto)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Override
    public UserDto findByEmail(String email) {
        return userRepository.findByEmail(email)
                .map(this::convertToDto)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Override
    public List<UserDto> findAll() {
        return userRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public UserDto update(Long id, UserDto userDto) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setUsername(userDto.getUsername());
        user.setEmail(userDto.getEmail());
        if (userDto.getAvatarUrl() != null) {
            user.setAvatarUrl(userDto.getAvatarUrl());
        }

        return convertToDto(userRepository.save(user));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public User getCurrentUser() {
        return (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }

    @Override
    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    private UserDto convertToDto(User user) {
        return UserDto.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .avatarUrl(user.getAvatarUrl())
                .role(user.getRole())
                .build();
    }
} 