package ru.kpfu.itis.music_service.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import okhttp3.HttpUrl;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
public class LastFmService {
    private final OkHttpClient client;
    private final ObjectMapper objectMapper;
    private final String apiKey;
    private final String baseUrl = "http://ws.audioscrobbler.com/2.0/";

    public LastFmService(@Value("${lastfm.api.key}") String apiKey) {
        this.client = new OkHttpClient();
        this.objectMapper = new ObjectMapper();
        this.apiKey = apiKey;
    }

    public JsonNode getArtistInfo(String artistName) throws IOException {
        HttpUrl url = HttpUrl.parse(baseUrl).newBuilder()
                .addQueryParameter("method", "artist.getinfo")
                .addQueryParameter("artist", artistName)
                .addQueryParameter("api_key", apiKey)
                .addQueryParameter("format", "json")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected response code: " + response);
            }
            String responseBody = response.body().string();
            log.info("Last.fm response for artist {}: {}", artistName, responseBody);
            return objectMapper.readTree(responseBody);
        }
    }

    public List<String> getSimilarArtists(String artistName) throws IOException {
        HttpUrl url = HttpUrl.parse(baseUrl).newBuilder()
                .addQueryParameter("method", "artist.getsimilar")
                .addQueryParameter("artist", artistName)
                .addQueryParameter("api_key", apiKey)
                .addQueryParameter("format", "json")
                .addQueryParameter("limit", "5")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected response code: " + response);
            }

            JsonNode root = objectMapper.readTree(response.body().string());
            List<String> similarArtists = new ArrayList<>();
            
            JsonNode artists = root.path("similarartists").path("artist");
            if (artists.isArray()) {
                for (JsonNode artist : artists) {
                    similarArtists.add(artist.path("name").asText());
                }
            }
            
            return similarArtists;
        }
    }

    public List<String> getArtistTopTracks(String artistName) throws IOException {
        HttpUrl url = HttpUrl.parse(baseUrl).newBuilder()
                .addQueryParameter("method", "artist.gettoptracks")
                .addQueryParameter("artist", artistName)
                .addQueryParameter("api_key", apiKey)
                .addQueryParameter("format", "json")
                .addQueryParameter("limit", "10")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected response code: " + response);
            }

            JsonNode root = objectMapper.readTree(response.body().string());
            List<String> topTracks = new ArrayList<>();
            
            JsonNode tracks = root.path("toptracks").path("track");
            if (tracks.isArray()) {
                for (JsonNode track : tracks) {
                    topTracks.add(track.path("name").asText());
                }
            }
            
            return topTracks;
        }
    }

    public List<String> getArtistTags(String artistName) throws IOException {
        HttpUrl url = HttpUrl.parse(baseUrl).newBuilder()
                .addQueryParameter("method", "artist.gettoptags")
                .addQueryParameter("artist", artistName)
                .addQueryParameter("api_key", apiKey)
                .addQueryParameter("format", "json")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected response code: " + response);
            }

            JsonNode root = objectMapper.readTree(response.body().string());
            List<String> tags = new ArrayList<>();
            
            JsonNode topTags = root.path("toptags").path("tag");
            if (topTags.isArray()) {
                for (JsonNode tag : topTags) {
                    tags.add(tag.path("name").asText());
                }
            }
            
            return tags;
        }
    }

    public JsonNode searchArtist(String query) throws IOException {
        HttpUrl url = HttpUrl.parse(baseUrl).newBuilder()
                .addQueryParameter("method", "artist.search")
                .addQueryParameter("artist", query)
                .addQueryParameter("api_key", apiKey)
                .addQueryParameter("format", "json")
                .addQueryParameter("limit", "5")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected response code: " + response);
            }
            return objectMapper.readTree(response.body().string());
        }
    }
} 