<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="${song.title} - ${song.artistName}">
    <div class="container py-5">
        <div class="row">
            <!-- Song Cover and Basic Info -->
            <div class="col-md-4">
                <img src="${song.coverUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg'}"
                     class="img-fluid rounded shadow" 
                     alt="${song.title}">
                <div class="mt-4">
                    <h1 class="h2 mb-1">${song.title}</h1>
                    <p class="text-muted mb-3">
                        <a href="/artists/${song.artistName}" class="text-decoration-none">${song.artistName}</a>
                    </p>
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <div class="text-muted">
                            <i class="bi bi-clock"></i> ${song.duration!'--:--'}
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <!-- Player -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="player">
                            <div class="player-content">
                                <div class="player-info d-flex align-items-center">
                                    <img src="${song.coverUrl!'/images/default-cover.jpg'}" 
                                         alt="${song.title}" 
                                         class="player-image me-3"
                                         style="width: 60px; height: 60px;">
                                    <div>
                                        <h4 class="mb-0">${song.title}</h4>
                                        <p class="text-muted mb-0">${song.artistName}</p>
                                    </div>
                                </div>
                                <div class="player-controls text-center my-3">
                                    <button class="btn btn-link text-dark" id="playPauseButton">
                                        <i class="bi bi-play-circle fs-1"></i>
                                    </button>
                                </div>
                                <div class="player-progress">
                                    <div class="progress" style="height: 6px;">
                                        <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                    </div>
                                    <div class="d-flex justify-content-between mt-2">
                                        <small class="text-muted" id="currentTime">0:00</small>
                                        <small class="text-muted" id="duration">0:00</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Additional Info -->
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">About this song</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-2">
                                    <strong>Artist:</strong>
                                    <a href="/artists/${song.artistName}" class="text-decoration-none">
                                        ${song.artistName}
                                    </a>
                                </p>
                                <p class="mb-2">
                                    <strong>Genre:</strong>
                                    <span class="text-muted">${song.genre!'Unknown'}</span>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-2">
                                    <strong>Release Date:</strong>
                                    <span class="text-muted">${song.releaseDate!'Unknown'}</span>
                                </p>
                                <p class="mb-2">
                                    <strong>Duration:</strong>
                                    <span class="text-muted">${song.duration!'--:--'}</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const audio = new Audio('${song.audioUrl}');
        const playPauseButton = document.getElementById('playPauseButton');
        const progressBar = document.querySelector('.progress-bar');
        const currentTimeDisplay = document.getElementById('currentTime');
        const durationDisplay = document.getElementById('duration');
        let isPlaying = false;

        playPauseButton.addEventListener('click', () => {
            if (isPlaying) {
                audio.pause();
                playPauseButton.innerHTML = '<i class="bi bi-play-circle fs-1"></i>';
            } else {
                audio.play();
                playPauseButton.innerHTML = '<i class="bi bi-pause-circle fs-1"></i>';
            }
            isPlaying = !isPlaying;
        });

        audio.addEventListener('timeupdate', () => {
            const progress = (audio.currentTime / audio.duration) * 100;
            progressBar.style.width = progress + '%';
            currentTimeDisplay.textContent = formatTime(audio.currentTime);
        });

        audio.addEventListener('loadedmetadata', () => {
            durationDisplay.textContent = formatTime(audio.duration);
        });

        function formatTime(seconds) {
            const minutes = Math.floor(seconds / 60);
            const remainingSeconds = Math.floor(seconds % 60);
            return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
        }
    </script>
</@base.page> 