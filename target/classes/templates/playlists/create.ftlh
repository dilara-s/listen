<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="Create New Playlist">
    <div class="container py-5">
        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Create New Playlist</h4>
                    </div>
                    <div class="card-body">
                        <form action="/playlists/create" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                            <div class="mb-3">
                                <div class="position-relative">
                                    <img src="https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg" 
                                         id="coverPreview"
                                         class="img-fluid rounded" 
                                         alt="Playlist cover">
                                    <label for="coverFile" 
                                           class="position-absolute top-50 start-50 translate-middle btn btn-light">
                                        <i class="bi bi-camera"></i> Choose Cover
                                    </label>
                                    <input type="file" 
                                           class="d-none" 
                                           id="coverFile" 
                                           name="cover" 
                                           accept="image/*"
                                           onchange="previewCover(this)">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="title" class="form-label">Playlist Title</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="title" 
                                       name="title" 
                                       required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" 
                                          id="description" 
                                          name="description" 
                                          rows="3"></textarea>
                            </div>

                            <!-- Hidden input for selected songs -->
                            <input type="hidden" name="selectedSongs" id="selectedSongs" value="">
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Create Playlist</button>
                                <a href="/playlists" class="btn btn-outline-secondary mt-2">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">Add Songs</h4>
                        <div class="input-group" style="width: 300px;">
                            <input type="text" 
                                   class="form-control" 
                                   placeholder="Search songs..." 
                                   id="songSearch"
                                   onkeyup="filterSongs(this.value)">
                            <span class="input-group-text">
                                <i class="bi bi-search"></i>
                            </span>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush" id="songsList">
                            <#if songs?? && songs?size gt 0>
                                <#list songs as song>
                                    <div class="list-group-item song-item" data-song-id="${song.id}">
                                        <div class="d-flex align-items-center">
                                            <div class="form-check">
                                                <input class="form-check-input song-checkbox" 
                                                       type="checkbox" 
                                                       value="${song.id}"
                                                       onchange="updateSelectedSongs()">
                                            </div>
                                            <img src="${song.coverUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg'}" 
                                                 class="rounded me-3" 
                                                 alt="${song.title}"
                                                 style="width: 40px; height: 40px; object-fit: cover;">
                                            <div>
                                                <h6 class="mb-0">${song.title}</h6>
                                                <small class="text-muted">${song.artistName}</small>
                                            </div>
                                            <button class="btn btn-link ms-auto preview-button" 
                                                    onclick="previewSong('${song.audioUrl}', this)">
                                                <i class="bi bi-play-fill"></i>
                                            </button>
                                        </div>
                                    </div>
                                </#list>
                            <#else>
                                <div class="text-center py-5">
                                    <i class="bi bi-music-note-list display-4 text-muted"></i>
                                    <p class="mt-3">No songs available</p>
                                </div>
                            </#if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let audio;
        let currentButton;

        function previewCover(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('coverPreview').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        function previewSong(url, button) {
            if (currentButton && currentButton !== button) {
                currentButton.innerHTML = '<i class="bi bi-play-fill"></i>';
            }

            if (audio) {
                audio.pause();
                if (currentButton === button) {
                    button.innerHTML = '<i class="bi bi-play-fill"></i>';
                    currentButton = null;
                    audio = null;
                    return;
                }
            }

            audio = new Audio(url);
            audio.play();
            button.innerHTML = '<i class="bi bi-pause-fill"></i>';
            currentButton = button;

            audio.onended = function() {
                button.innerHTML = '<i class="bi bi-play-fill"></i>';
                currentButton = null;
                audio = null;
            };
        }

        function updateSelectedSongs() {
            const selectedSongs = Array.from(document.querySelectorAll('.song-checkbox:checked'))
                .map(checkbox => checkbox.value);
            document.getElementById('selectedSongs').value = selectedSongs.join(',');
        }

        function filterSongs(query) {
            query = query.toLowerCase();
            const items = document.querySelectorAll('.song-item');
            
            items.forEach(item => {
                const title = item.querySelector('h6').textContent.toLowerCase();
                const artist = item.querySelector('small').textContent.toLowerCase();
                
                if (title.includes(query) || artist.includes(query)) {
                    item.style.display = '';
                } else {
                    item.style.display = 'none';
                }
            });
        }
    </script>
</@base.page> 