<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="${playlist.title}">
    <div class="container py-5">
        <!-- Playlist Header -->
        <div class="row mb-5">
            <div class="col-md-4">
                <img src="${playlist.coverUrl}"
                     class="img-fluid rounded-3 shadow-lg"
                     alt="${playlist.title}"
                     style="width: 100%; height: 300px; object-fit: cover;">
            </div>
            <div class="col-md-8">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h1 class="display-4 mb-2">${playlist.title}</h1>
                        <p class="lead text-muted mb-4">${playlist.description!''}</p>
                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div class="text-muted">
                                <i class="bi bi-music-note"></i> ${playlist.songs?size} songs
                            </div>
                        </div>
                        <div class="d-flex gap-2">
                            <button class="btn btn-primary btn-lg">
                                <i class="bi bi-play-fill"></i> Play All
                            </button>
                            <button class="btn btn-outline-primary btn-lg">
                                <i class="bi bi-shuffle"></i> Shuffle
                            </button>
                        </div>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-outline-secondary rounded-circle p-2"
                                type="button"
                                data-bs-toggle="dropdown">
                            <i class="bi bi-three-dots"></i>
                        </button>
                        <ul class="dropdown-menu">
                            <li>
                                <a class="dropdown-item" href="/playlists/${playlist.id}/edit">
                                    <i class="bi bi-pencil"></i> Edit Playlist
                                </a>
                            </li>
                            <li>
                                <button class="dropdown-item text-danger"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal">
                                    <i class="bi bi-trash"></i> Delete Playlist
                                </button>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Songs List -->
        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 50px" class="text-muted">#</th>
                                <th>Title</th>
                                <th>Artist</th>
                                <th style="width: 50px"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list playlist.songs as song>
                                <tr>
                                    <td class="text-muted">${song?counter}</td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${song.coverUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg'}"
                                                 style="width: 40px; height: 40px"
                                                 class="rounded-3 me-3 shadow-sm"
                                                 alt="${song.title}">
                                            <div>
                                                <div class="fw-medium">${song.title}</div>
                                                <small class="text-muted d-block d-md-none">${song.artistName}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="d-none d-md-table-cell">
                                        <a href="/artists/${song.artistName}" class="text-decoration-none">
                                            ${song.artistName}
                                        </a>
                                    </td>
                                    <td>
                                        <button class="btn btn-link play-button p-0" 
                                                data-song-index="${song?index}"
                                                data-playing="false">
                                            <i class="bi bi-play-fill"></i>
                                        </button>
                                    </td>
                                    <td>
                                        <button class="btn btn-link text-danger p-0" onclick="removeSong(${song.id})">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            <#else>
                                <tr>
                                    <td colspan="4" class="text-center py-5">
                                        <i class="bi bi-music-note-list display-1 text-muted"></i>
                                        <h5 class="mt-3">This playlist is empty</h5>
                                        <p class="text-muted">Add some songs to get started!</p>
                                        <a href="/playlists/${playlist.id}/edit" class="btn btn-primary">
                                            <i class="bi bi-plus-lg"></i> Add Songs
                                        </a>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Delete Playlist</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete "${playlist.title}"? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form action="/playlists/${playlist.id}/delete" method="POST" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
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

    <script>
        let audio;
        let currentSongIndex = -1;
        let isPlaying = false;
        let isRepeat = false;
        let isShuffle = false;
        const songs = [
            <#if playlist.songs?? && playlist.songs?size gt 0>
                <#list playlist.songs as song>
                    {
                        id: ${song.id},
                        title: '${song.title}',
                        artist: '${song.artistName}',
                        cover: '${song.coverUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg'}',
                        audio: '${song.audioUrl}'
                    }<#if song?has_next>,</#if>
                </#list>
            </#if>
        ];

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
                btn.dataset.playing = 'false';
                btn.innerHTML = '<i class="bi bi-play-fill"></i>';
            });

            if (currentSongIndex === index && isPlaying) {
                audio.pause();
                isPlaying = false;
                button.dataset.playing = 'false';
                button.innerHTML = '<i class="bi bi-play-fill"></i>';
                document.getElementById('playPauseButton').innerHTML = '<i class="bi bi-play-circle-fill fs-2"></i>';
            } else {
                if (currentSongIndex !== index) {
                    currentSongIndex = index;
                    initializeAudio(index);
                }
                audio.play();
                isPlaying = true;
                button.dataset.playing = 'true';
                button.innerHTML = '<i class="bi bi-pause-fill"></i>';
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

        // Add click event listeners to all play buttons
        document.querySelectorAll('.play-button').forEach(button => {
            button.addEventListener('click', () => playSong(button));
        });

        // Add click event listeners to Play All and Shuffle buttons
        document.querySelector('.btn-primary.btn-lg').addEventListener('click', () => {
            const firstPlayButton = document.querySelector('.play-button');
            if (firstPlayButton) {
                playSong(firstPlayButton);
            }
        });

        document.querySelector('.btn-outline-primary.btn-lg').addEventListener('click', () => {
            isShuffle = true;
            document.getElementById('shuffleButton').classList.add('text-primary');
            const randomIndex = Math.floor(Math.random() * songs.length);
            const randomButton = document.querySelector('.play-button[data-song-index="' + randomIndex + '"]');
            if (randomButton) {
                playSong(randomButton);
            }
        });

        function removeSong(songId) {
            if (confirm('Remove this song from the playlist?')) {
                fetch('/api/playlists/' + ${playlist.id} + '/songs/'+ songId, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }).then(response => {
                    if (response.ok) {
                        location.reload();
                    }
                });
            }
        }
    </script>

    <style>
        .favorite-btn, .play-button {
            border: none;
            background: none;
            padding: 0;
            cursor: pointer;
        }
        .favorite-btn i, .play-button i {
            font-size: 1.2rem;
        }
        .favorite-btn:hover i, .play-button:hover i {
            transform: scale(1.1);
        }
        .favorite-btn i, .play-button i {
            transition: all 0.3s ease;
        }
        #player {
            z-index: 1000;
        }
    </style>
</@base.page>