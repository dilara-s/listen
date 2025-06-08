package ru.kpfu.itis.music_service.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ru.kpfu.itis.music_service.entity.Artist;
import ru.kpfu.itis.music_service.service.ArtistEnrichmentService;
import ru.kpfu.itis.music_service.repository.SongRepository;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/artists")
@RequiredArgsConstructor
public class ArtistController {
    private final ArtistEnrichmentService artistService;
    private final SongRepository songRepository;

    @GetMapping
    public String listArtists(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String tag,
            Model model) {
        List<Artist> artists;
        
        if (query != null && !query.trim().isEmpty()) {
            artists = artistService.searchArtists(query);
            model.addAttribute("query", query);
        } else if (tag != null && !tag.trim().isEmpty()) {
            artists = artistService.findByTag(tag);
            model.addAttribute("selectedTag", tag);
        } else {
            artists = artistService.getPopularArtists();
        }
        
        model.addAttribute("artists", artists);
        return "artists/list";
    }

    @GetMapping("/{name}")
    public String getArtistDetails(@PathVariable String name, Model model) {
        try {
            // Try to find or create artist with Last.fm info
            Artist artist = artistService.createOrUpdateArtist(name);
            
            // Get artist's songs from our database
            var songs = songRepository.findByArtistName(artist.getName());
            
            model.addAttribute("artist", artist);
            model.addAttribute("songs", songs);
            
            return "artists/details";
        } catch (IOException e) {
            model.addAttribute("error", "Failed to load artist information: " + e.getMessage());
            return "error";
        }
    }
} 