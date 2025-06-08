package ru.kpfu.itis.music_service.service;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.music_service.entity.Artist;
import ru.kpfu.itis.music_service.repository.ArtistRepository;
import ru.kpfu.itis.music_service.util.CloudinaryUtil;

import java.io.IOException;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class ArtistEnrichmentService {
    private final LastFmService lastFmService;
    private final ArtistRepository artistRepository;
    private final CloudinaryUtil cloudinaryUtil;

    public Artist createOrUpdateArtist(String artistName) throws IOException {
        log.info("Creating or updating artist: {}", artistName);
        
        Artist artist = artistRepository.findByName(artistName)
                .orElse(Artist.builder().name(artistName).build());

        // Получаем информацию из Last.fm
        JsonNode lastFmInfo = lastFmService.getArtistInfo(artistName);
        List<String> similarArtists = lastFmService.getSimilarArtists(artistName);
        List<String> tags = lastFmService.getArtistTags(artistName);
        List<String> topTracks = lastFmService.getArtistTopTracks(artistName);

        // Обновляем информацию артиста
        artist.setBiography(lastFmInfo.path("artist").path("bio").path("content").asText());
        artist.setTags(tags);
        artist.setSimilarArtists(similarArtists);
        //artist.setTopTracks(topTracks);

        // Если у артиста еще нет изображения, попробуем получить его из Last.fm
        if (artist.getImageUrl() == null || artist.getImageUrl().isEmpty()) {
            log.info("Artist {} has no image, trying to get from Last.fm", artistName);
            JsonNode images = lastFmInfo.path("artist").path("image");
            log.info("Found {} images for artist {}", images.size(), artistName);
            
            if (images.isArray() && images.size() > 0) {
                // Берем самое большое изображение (последнее в массиве)
                JsonNode largestImage = images.get(images.size() - 1);
                String imageUrl = largestImage.path("#text").asText();
                log.info("Largest image URL for artist {}: {}", artistName, imageUrl);
                
                // Проверяем, что URL не пустой и действительно является URL изображения
                if (imageUrl != null && !imageUrl.isEmpty() && 
                    (imageUrl.startsWith("http://") || imageUrl.startsWith("https://"))) {
                    try {
                        log.info("Trying to upload image to Cloudinary for artist {}", artistName);
                        // Загружаем изображение в Cloudinary
                        String cloudinaryUrl = cloudinaryUtil.uploadFromUrl(imageUrl, "artists/" + artist.getName());
                        log.info("Successfully uploaded image to Cloudinary for artist {}: {}", artistName, cloudinaryUrl);
                        artist.setImageUrl(cloudinaryUrl);
                    } catch (Exception e) {
                        // Если не удалось загрузить изображение, используем дефолтное
                        log.error("Failed to upload image to Cloudinary for artist {}: {}", artistName, e.getMessage());
                        artist.setImageUrl("https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg");
                        e.printStackTrace();
                    }
                } else {
                    // Если нет подходящего URL, используем дефолтное изображение
                    log.info("No valid image URL found for artist {}, using default image", artistName);
                    artist.setImageUrl("https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg");
                }
            } else {
                log.info("No images found for artist {} in Last.fm response", artistName);
            }
        } else {
            log.info("Artist {} already has an image: {}", artistName, artist.getImageUrl());
        }

        return artistRepository.save(artist);
    }

    public Map<String, Object> getArtistInfo(String artistName) throws IOException {
        Artist artist = artistRepository.findByName(artistName)
                .orElseThrow(() -> new NoSuchElementException("Artist not found: " + artistName));

        Map<String, Object> artistInfo = new HashMap<>();
        artistInfo.put("id", artist.getId());
        artistInfo.put("name", artist.getName());
        artistInfo.put("biography", artist.getBiography());
        artistInfo.put("imageUrl", artist.getImageUrl());
        artistInfo.put("tags", artist.getTags());
        artistInfo.put("similarArtists", artist.getSimilarArtists());
       // artistInfo.put("topTracks", artist.getTopTracks());

        return artistInfo;
    }

    public List<Artist> searchArtists(String query) {
        // Сначала ищем в локальной базе данных
        List<Artist> localResults = artistRepository.findByNameContainingIgnoreCase(query);
        
        // Если локально ничего не нашли, пробуем искать через Last.fm
        if (localResults.isEmpty()) {
            try {
                JsonNode searchResults = lastFmService.searchArtist(query);
                JsonNode artists = searchResults.path("results").path("artistmatches").path("artist");
                
                if (artists.isArray()) {
                    for (JsonNode artistNode : artists) {
                        String artistName = artistNode.path("name").asText();
                        try {
                            // Получаем подробную информацию об артисте и сохраняем в базу
                            Artist artist = createOrUpdateArtist(artistName);
                            if (artist != null) {
                                localResults.add(artist);
                            }
                        } catch (IOException e) {
                            // Логируем ошибку, но продолжаем обработку следующих артистов
                            e.printStackTrace();
                        }
                    }
                }
            } catch (IOException e) {
                // Логируем ошибку, но не прерываем выполнение
                e.printStackTrace();
            }
        }
        
        return localResults;
    }

    public List<Artist> getPopularArtists() {
        // Можно реализовать логику получения популярных артистов
        // Например, первые 10 артистов с наибольшим количеством тегов
        return artistRepository.findTop10ByOrderByTagsSizeDesc();
    }

    public List<Artist> findByTag(String tag) {
        return artistRepository.findByTagsContaining(tag);
    }
} 