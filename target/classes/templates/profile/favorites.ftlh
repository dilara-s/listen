<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="${user.username}'s Favorite Songs">
    <div class="container py-5">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-0">${user.username}'s Favorite Songs</h2>
                <p class="text-muted">
                    <#if songs?size == 1>
                        1 song
                    <#else>
                        ${songs?size} songs
                    </#if>
                </p>
            </div>
            <#if currentUser?? && currentUser.id == user.id>
                <a href="/songs" class="btn btn-outline-primary">
                    <i class="bi bi-plus-lg"></i> Add More
                </a>
            </#if>
        </div>

        <!-- Songs List -->
        <div class="card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th style="width: 50px">#</th>
                                <th>Title</th>
                                <th>Artist</th>
                                <#if currentUser?? && currentUser.id == user.id>
                                    <th style="width: 50px"></th>
                                </#if>
                            </tr>
                        </thead>
                        <tbody>
                            <#if songs?? && songs?size gt 0>
                                <#list songs as song>
                                    <tr>
                                        <td class="text-muted">${song?counter}</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="${song.coverUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg'}" 
                                                     style="width: 40px; height: 40px" 
                                                     class="me-3" 
                                                     alt="${song.title}">
                                                <div>
                                                    <div>${song.title}</div>
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
                                        <#if currentUser?? && currentUser.id == user.id>
                                            <td>
                                                <button class="btn btn-link favorite-btn p-0" 
                                                        onclick="removeFavorite(this, ${song.id})"
                                                        data-favorite="true">
                                                    <i class="bi bi-heart-fill" style="color: #dc3545; transition: color 0.3s ease;"></i>
                                                </button>
                                            </td>
                                        </#if>
                                    </tr>
                                </#list>
                            <#else>
                                <tr>
                                    <td colspan="4" class="text-center py-5">
                                        <i class="bi bi-heart display-1 text-muted"></i>
                                        <h5 class="mt-3">No favorite songs yet</h5>
                                        <p class="text-muted">Start adding songs to your favorites!</p>
                                        <a href="/songs" class="btn btn-primary">Browse Songs</a>
                                    </td>
                                </tr>
                            </#if>
                        </tbody>
                    </table>
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
    </div>

    <script>
        let audio;
        let currentSongIndex = -1;
        let isPlaying = false;
        let isRepeat = false;
        let isShuffle = false;
        const songs = [
            <#if songs?? && songs?size gt 0>
                <#list songs as song>
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

        function removeFavorite(button, songId) {
            const url = '/api/songs/' + songId + '/favorite';

            fetch(url, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]').value
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                // Remove the row from the table
                button.closest('tr').remove();
                
                // Check if there are any songs left
                const tbody = document.querySelector('tbody');
                if (!tbody.querySelector('tr')) {
                    // If no songs left, show the empty state
                    tbody.innerHTML = `
                        <tr>
                            <td colspan="4" class="text-center py-5">
                                <i class="bi bi-heart display-1 text-muted"></i>
                                <h5 class="mt-3">No favorite songs yet</h5>
                                <p class="text-muted">Start adding songs to your favorites!</p>
                                <a href="/songs" class="btn btn-primary">Browse Songs</a>
                            </td>
                        </tr>
                    `;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to remove from favorites. Please try again.');
            });
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