<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="Songs">
    <div class="container py-5">
        <!-- Hidden CSRF field -->
        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
        <input type="hidden" name="_csrf_header" value="${_csrf.headerName}"/>
        
        <!-- Search and Upload Section -->
        <div class="row mb-5">
            <div class="col-lg-8 mx-auto">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="flex-grow-1 me-3">
                        <div class="input-group">
                            <input type="text" 
                                   class="form-control" 
                                   id="searchInput" 
                                   placeholder="Search songs..."
                                   value="${query!''}"
                                   onkeyup="debounceSearch(this.value)">
                            <button class="btn btn-outline-secondary" type="button">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </div>
                    <#if currentUser?? && currentUser.role == 'ADMIN'>
                        <a href="/songs/upload" class="btn btn-primary">
                            <i class="bi bi-plus-lg"></i> Upload Song
                        </a>
                    </#if>
                </div>
            </div>
        </div>

        <!-- Songs Grid -->
        <div class="row g-4" id="songsList">
            <#if songs?? && songs?size gt 0>
                <#list songs as song>
                    <div class="col-sm-6 col-lg-4">
                        <div class="card h-100 shadow-sm">
                            <div class="position-relative">
                                <img src="${song.coverUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg'}" 
                                     class="card-img-top" 
                                     alt="${song.title}"
                                     style="height: 250px; object-fit: cover;">
                                <button class="btn btn-primary position-absolute play-button" 
                                        style="bottom: 1rem; right: 1rem; border-radius: 50%; width: 3rem; height: 3rem;"
                                        data-song-index="${song?index}"
                                        data-playing="false">
                                    <i class="bi bi-play-fill fs-4"></i>
                                </button>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title text-truncate">${song.title}</h5>
                                <p class="card-text text-muted mb-3">${song.artistName}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="btn-group">
                                        <#if currentUser??>
                                            <button type="button" 
                                                    class="btn btn-sm favorite-btn" 
                                                    onclick="toggleFavorite(this)"
                                                    data-song-id="${song.id?c}"
                                                    data-favorite="${song.favorite?string}">
                                                <i class="bi bi-heart-fill" style="color: ${(song.favorite)?then('#dc3545', '#6c757d')}; transition: color 0.2s;"></i>
                                            </button>
                                        </#if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </#list>
            <#else>
                <div class="col-12 text-center py-5">
                    <i class="bi bi-music-note-list display-1 text-muted"></i>
                    <h3 class="mt-3">No songs found</h3>
                    <p class="text-muted">Try different search terms or upload new songs</p>
                    <#if currentUser?? && currentUser.role == 'ADMIN'>
                        <a href="/songs/upload" class="btn btn-primary mt-3">
                            <i class="bi bi-plus-lg"></i> Upload Song
                        </a>
                    </#if>
                </div>
            </#if>
        </div>

        <!-- Player -->
        <div class="fixed-bottom bg-white border-top shadow-lg py-3" id="player" style="display: none;">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <div class="d-flex align-items-center">
                            <img id="playerCover" 
                                 src="" 
                                 alt="" 
                                 style="width: 50px; height: 50px; object-fit: cover;" 
                                 class="rounded me-3">
                            <div>
                                <h6 id="playerTitle" class="mb-0 text-truncate"></h6>
                                <small id="playerArtist" class="text-muted"></small>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-flex flex-column align-items-center">
                            <div class="mb-2">
                                <button class="btn btn-link text-dark" onclick="playPrevious()">
                                    <i class="bi bi-skip-backward-fill fs-4"></i>
                                </button>
                                <button class="btn btn-link text-dark" onclick="togglePlay()" id="playPauseButton">
                                    <i class="bi bi-play-circle-fill fs-2"></i>
                                </button>
                                <button class="btn btn-link text-dark" onclick="playNext()">
                                    <i class="bi bi-skip-forward-fill fs-4"></i>
                                </button>
                            </div>
                            <div class="w-100 px-3">
                                <div class="progress" style="height: 4px; cursor: pointer;" onclick="seek(event)">
                                    <div class="progress-bar" id="progressBar" role="progressbar"></div>
                                </div>
                                <div class="d-flex justify-content-between mt-1">
                                    <small class="text-muted" id="currentTime">0:00</small>
                                    <small class="text-muted" id="duration">0:00</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-flex justify-content-end align-items-center">
                            <button class="btn btn-link text-dark" onclick="toggleRepeat()" id="repeatButton">
                                <i class="bi bi-repeat fs-5"></i>
                            </button>
                            <button class="btn btn-link text-dark" onclick="toggleShuffle()" id="shuffleButton">
                                <i class="bi bi-shuffle fs-5"></i>
                            </button>
                            <div class="d-flex align-items-center ms-3">
                                <i class="bi bi-volume-up me-2"></i>
                                <input type="range" 
                                       class="form-range" 
                                       min="0" 
                                       max="100" 
                                       value="100"
                                       style="width: 100px;"
                                       oninput="setVolume(this.value)">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let searchTimeout;
        let audio;
        let currentSongIndex = -1;
        let isPlaying = false;
        let isRepeat = false;
        let isShuffle = false;
        const songs = [
            <#if songs?? && songs?size gt 0>
                <#list songs as song>
                    {
                        id: ${song.id?c},
                        title: "${song.title}",
                        artist: "${song.artistName}",
                        cover: "${song.coverUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg'}",
                        audio: "${song.audioUrl}"
                    }<#if song?has_next>,</#if>
                </#list>
            </#if>
        ];

        function debounceSearch(query) {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                window.location.href = '/songs' + (query ? '?query=' + encodeURIComponent(query) : '');
            }, 300);
        }

        function initializeAudio(songIndex) {
            if (audio) {
                audio.pause();
            }

            const song = songs[songIndex];
            audio = new Audio(song.audio);
            
            audio.addEventListener('timeupdate', updateProgress);
            audio.addEventListener('loadedmetadata', () => {
                document.getElementById('duration').textContent = formatTime(audio.duration);
            });
            audio.addEventListener('ended', () => {
                if (isRepeat) {
                    audio.currentTime = 0;
                    audio.play();
                } else {
                    playNext();
                }
            });

            document.getElementById('playerCover').src = song.cover;
            document.getElementById('playerTitle').textContent = song.title;
            document.getElementById('playerArtist').textContent = song.artist;
            document.getElementById('player').style.display = 'block';
        }

        function updateProgress() {
            const progress = (audio.currentTime / audio.duration) * 100;
            document.getElementById('progressBar').style.width = progress + '%';
            document.getElementById('currentTime').textContent = formatTime(audio.currentTime);
        }

        function seek(event) {
            const progressBar = event.currentTarget;
            const clickPosition = (event.pageX - progressBar.offsetLeft) / progressBar.offsetWidth;
            audio.currentTime = clickPosition * audio.duration;
        }

        function playSong(button) {
            const index = parseInt(button.dataset.songIndex);
            const allButtons = document.querySelectorAll('.play-button[data-playing="true"]');
            allButtons.forEach(btn => {
                btn.dataset.playing = "false";
                btn.innerHTML = '<i class="bi bi-play-fill fs-4"></i>';
            });

            if (currentSongIndex === index && isPlaying) {
                audio.pause();
                isPlaying = false;
                button.dataset.playing = "false";
                button.innerHTML = '<i class="bi bi-play-fill fs-4"></i>';
                document.getElementById('playPauseButton').innerHTML = '<i class="bi bi-play-circle-fill fs-2"></i>';
            } else {
                if (currentSongIndex !== index) {
                    currentSongIndex = index;
                    initializeAudio(index);
                }
                audio.play();
                isPlaying = true;
                button.dataset.playing = "true";
                button.innerHTML = '<i class="bi bi-pause-fill fs-4"></i>';
                document.getElementById('playPauseButton').innerHTML = '<i class="bi bi-pause-circle-fill fs-2"></i>';
            }
        }

        function togglePlay() {
            if (currentSongIndex === -1) {
                const firstPlayButton = document.querySelector('.play-button');
                if (firstPlayButton) {
                    playSong(firstPlayButton);
                }
            } else {
                const currentPlayButton = document.querySelector('.play-button[data-song-index="' + currentSongIndex + '"]');
                if (currentPlayButton) {
                    playSong(currentPlayButton);
                }
            }
        }

        function playNext() {
            let nextIndex = currentSongIndex + 1;
            if (isShuffle) {
                nextIndex = Math.floor(Math.random() * songs.length);
            }
            if (nextIndex >= songs.length) {
                nextIndex = 0;
            }
            const nextButton = document.querySelector('.play-button[data-song-index="' + nextIndex + '"]');
            if (nextButton) {
                playSong(nextButton);
            }
        }

        function playPrevious() {
            let prevIndex = currentSongIndex - 1;
            if (prevIndex < 0) {
                prevIndex = songs.length - 1;
            }
            const prevButton = document.querySelector('.play-button[data-song-index="' + prevIndex + '"]');
            if (prevButton) {
                playSong(prevButton);
            }
        }

        function toggleRepeat() {
            isRepeat = !isRepeat;
            const button = document.getElementById('repeatButton');
            button.classList.toggle('text-primary', isRepeat);
        }

        function toggleShuffle() {
            isShuffle = !isShuffle;
            const button = document.getElementById('shuffleButton');
            button.classList.toggle('text-primary', isShuffle);
        }

        function setVolume(value) {
            if (audio) {
                audio.volume = value / 100;
            }
        }

        function formatTime(seconds) {
            const minutes = Math.floor(seconds / 60);
            const remainingSeconds = Math.floor(seconds % 60);
            return minutes + ':' + remainingSeconds.toString().padStart(2, '0');
        }

        function toggleFavorite(button) {
            const songId = button.getAttribute('data-song-id');
            const isFavorite = button.getAttribute('data-favorite') === 'true';
            const method = isFavorite ? 'DELETE' : 'POST';
            const url = '/api/songs/' + songId + '/favorite';
            
            button.disabled = true;
            
            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                console.log('Response status:', response.status);
                if (response.ok) {
                    const heartIcon = button.querySelector('i');
                    if (isFavorite) {
                        // Remove from favorites
                        heartIcon.style.color = '#6c757d';
                        button.setAttribute('data-favorite', 'false');
                        console.log('Removed from favorites');
                    } else {
                        // Add to favorites
                        heartIcon.style.color = '#dc3545';
                        button.setAttribute('data-favorite', 'true');
                        console.log('Added to favorites');
                    }
                } else {
                    throw new Error('Failed to update favorite status: ' + response.status);
                }
            })
            .catch(error => {
                console.error('Error details:', error);
                alert('Failed to update favorite status. Please try again.');
            })
            .finally(() => {
                button.disabled = false;
            });
        }

        // Add click event listeners to all play buttons
        document.querySelectorAll('.play-button').forEach(button => {
            button.addEventListener('click', () => playSong(button));
        });
    </script>
</@base.page>
 