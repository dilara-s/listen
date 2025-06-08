class MusicPlayer {
    constructor() {
        this.audio = new Audio();
        this.isPlaying = false;
        this.currentSongId = null;
        this.playlist = [];
        this.currentIndex = 0;

        this.initializeElements();
        this.initializeEventListeners();
    }

    initializeElements() {
        this.playPauseButton = document.getElementById('playPauseButton');
        this.prevButton = document.getElementById('prevButton');
        this.nextButton = document.getElementById('nextButton');
        this.progressBar = document.querySelector('.progress-bar');
        this.progress = document.querySelector('.progress');
        this.currentTimeSpan = document.getElementById('currentTime');
        this.durationSpan = document.getElementById('duration');
        this.playButtons = document.querySelectorAll('.play-button');
    }

    initializeEventListeners() {
        // Play/Pause button
        this.playPauseButton.addEventListener('click', () => this.togglePlayPause());

        // Previous and Next buttons
        this.prevButton.addEventListener('click', () => this.playPrevious());
        this.nextButton.addEventListener('click', () => this.playNext());

        // Progress bar
        this.progressBar.addEventListener('click', (e) => this.seek(e));

        // Audio events
        this.audio.addEventListener('timeupdate', () => this.updateProgress());
        this.audio.addEventListener('ended', () => this.playNext());
        this.audio.addEventListener('loadedmetadata', () => this.updateDuration());

        // Play buttons in song cards
        this.playButtons.forEach(button => {
            button.addEventListener('click', () => {
                const songId = button.dataset.songId;
                this.playSong(songId);
            });
        });
    }

    async playSong(songId) {
        try {
            const response = await fetch(`/api/songs/${songId}`);
            const song = await response.json();
            
            if (this.currentSongId !== songId) {
                this.audio.src = song.audioUrl;
                this.currentSongId = songId;
                this.updatePlayerInfo(song);
            }
            
            this.togglePlayPause();
        } catch (error) {
            console.error('Error playing song:', error);
        }
    }

    togglePlayPause() {
        if (this.audio.paused) {
            this.audio.play();
            this.playPauseButton.textContent = '⏸';
            this.isPlaying = true;
        } else {
            this.audio.pause();
            this.playPauseButton.textContent = '⏯';
            this.isPlaying = false;
        }
    }

    playPrevious() {
        if (this.currentIndex > 0) {
            this.currentIndex--;
            const previousSong = this.playlist[this.currentIndex];
            this.playSong(previousSong.id);
        }
    }

    playNext() {
        if (this.currentIndex < this.playlist.length - 1) {
            this.currentIndex++;
            const nextSong = this.playlist[this.currentIndex];
            this.playSong(nextSong.id);
        }
    }

    seek(e) {
        const percent = e.offsetX / this.progressBar.offsetWidth;
        this.audio.currentTime = percent * this.audio.duration;
        this.updateProgress();
    }

    updateProgress() {
        const percent = (this.audio.currentTime / this.audio.duration) * 100;
        this.progress.style.width = `${percent}%`;
        this.currentTimeSpan.textContent = this.formatTime(this.audio.currentTime);
    }

    updateDuration() {
        this.durationSpan.textContent = this.formatTime(this.audio.duration);
    }

    updatePlayerInfo(song) {
        const playerImage = document.querySelector('.player-image');
        const playerTitle = document.querySelector('.player-info h4');
        const playerArtist = document.querySelector('.player-info p');

        if (playerImage) playerImage.src = song.coverUrl;
        if (playerTitle) playerTitle.textContent = song.title;
        if (playerArtist) playerArtist.textContent = song.artist;
    }

    formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = Math.floor(seconds % 60);
        return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
    }
}

// Initialize player when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    const player = new MusicPlayer();
}); 