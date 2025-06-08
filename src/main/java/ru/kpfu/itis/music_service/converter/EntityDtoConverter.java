package ru.kpfu.itis.music_service.converter;

public interface EntityDtoConverter<E, D> {
    D toDto(E entity);
    E toEntity(D dto);
} 