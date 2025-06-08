package ru.kpfu.itis.music_service.converter;

import org.springframework.stereotype.Component;
import ru.kpfu.itis.music_service.config.AppConfig;
import ru.kpfu.itis.music_service.dto.UserDto;
import ru.kpfu.itis.music_service.entity.Role;
import ru.kpfu.itis.music_service.entity.User;

@Component
public class UserConverter implements EntityDtoConverter<User, UserDto> {
    
    @Override
    public UserDto toDto(User entity) {
        if (entity == null) {
            return null;
        }
        
        String avatarUrl = entity.getAvatarUrl();
        if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
            avatarUrl = AppConfig.DEFAULT_USER_AVATAR_URL;
        }
        
        return UserDto.builder()
                .id(entity.getId())
                .username(entity.getUsername())
                .email(entity.getEmail())
                .avatarUrl(avatarUrl)
                .role(Role.valueOf(entity.getRole().name()))
                .build();
    }
    
    @Override
    public User toEntity(UserDto dto) {
        if (dto == null) {
            return null;
        }
        
        String avatarUrl = dto.getAvatarUrl();
        if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
            avatarUrl = AppConfig.DEFAULT_USER_AVATAR_URL;
        }
        
        return User.builder()
                .id(dto.getId())
                .username(dto.getUsername())
                .email(dto.getEmail())
                .avatarUrl(avatarUrl)
                .build();
    }
} 