package ru.kpfu.itis.music_service.service;

import ru.kpfu.itis.music_service.dto.UserDto;
import ru.kpfu.itis.music_service.dto.UserRegistrationDto;
import ru.kpfu.itis.music_service.entity.User;

import java.util.List;

public interface UserService {
    UserDto register(UserRegistrationDto registrationDto);
    UserDto findById(Long id);
    UserDto findByUsername(String username);
    UserDto findByEmail(String email);
    List<UserDto> findAll();
    UserDto update(Long id, UserDto userDto);
    void delete(Long id);
    User getCurrentUser();
    User getUserById(Long id);
} 