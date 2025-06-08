<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="Edit ${playlist.title}">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card mb-4">
                    <div class="card-header">
                        <h4 class="mb-0">Edit Playlist</h4>
                    </div>
                    <div class="card-body">
                        <form action="/playlists/${playlist.id}/update" method="POST" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <div class="position-relative" style="aspect-ratio: 1; overflow: hidden; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
                                            <img src="${playlist.coverUrl}" 
                                                 id="coverPreview"
                                                 class="img-fluid w-100 h-100"
                                                 style="object-fit: cover;"
                                                 alt="Playlist cover">
                                            <label for="coverFile" 
                                                   class="position-absolute top-50 start-50 translate-middle btn btn-light rounded-circle p-3"
                                                   style="background: rgba(255,255,255,0.9);">
                                                <i class="bi bi-camera fs-4"></i>
                                            </label>
                                            <div class="position-absolute bottom-0 start-0 end-0 p-3 text-center"
                                                 style="background: linear-gradient(transparent, rgba(0,0,0,0.7));">
                                                <small class="text-white">Click to change cover</small>
                                            </div>
                                            <input type="file" 
                                                   class="d-none" 
                                                   id="coverFile" 
                                                   name="cover" 
                                                   accept="image/*"
                                                   onchange="previewCover(this)">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-8">
                                    <div class="mb-3">
                                        <label for="title" class="form-label">Playlist Title</label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="title" 
                                               name="title" 
                                               value="${playlist.title}"
                                               required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Description</label>
                                        <textarea class="form-control" 
                                                  id="description" 
                                                  name="description" 
                                                  rows="3">${playlist.description?default('')}</textarea>
                                    </div>
                                </div>
                            </div>
                            
                            <hr class="my-4">
                            
                            <div class="d-flex justify-content-between">
                                <a href="/playlists/${playlist.id}" class="btn btn-outline-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Songs Management -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Songs</h5>
                        <button class="btn btn-primary btn-sm" onclick="openSearchModal()">
                            <i class="bi bi-plus-lg"></i> Add Songs
                        </button>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Artist</th>
                                        <th style="width: 50px"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <#list playlist.songs as song>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${song.coverUrl?default('https://res.cloudinary.com/dsyuw4byo/image/upload/v1749381928/4a86344f69940e6b166c0bcbde36c3bc_om4gev.jpg')}"
                                                         style="width: 40px; height: 40px; object-fit: cover;" 
                                                         class="me-3 rounded">
                                                    <div>
                                                        <div>${song.title}</div>
                                                        <small class="text-muted d-block d-md-none">${song.artistName}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="d-none d-md-table-cell">${song.artistName}</td>
                                            <td>
                                                <button class="btn btn-link text-danger" onclick="removeSong(${song.id})">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    <#else>
                                        <tr>
                                            <td colspan="3" class="text-center py-5">
                                                <i class="bi bi-music-note-list display-1 text-muted"></i>
                                                <h5 class="mt-3">No songs in playlist</h5>
                                                <p class="text-muted">Add some songs to get started!</p>
                                            </td>
                                        </tr>
                                    </#list>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Search Songs Modal -->
    <div class="modal fade" id="searchModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Songs</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-4">
                        <div class="input-group">
                            <input type="text" 
                                   class="form-control" 
                                   id="searchInput" 
                                   placeholder="Search for songs..."
                                   onkeyup="debounceSearch(this.value)">
                            <button class="btn btn-outline-secondary" type="button">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </div>
                    <div id="searchResults" class="list-group"></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Cover preview
        function previewCover(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('coverPreview').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // Song search and add functionality
        let searchTimeout;
        const searchModal = new bootstrap.Modal(document.getElementById('searchModal'));

        function openSearchModal() {
            searchModal.show();
            document.getElementById('searchInput').focus();
        }

        function debounceSearch(query) {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => searchSongs(query), 300);
        }

        function searchSongs(query) {
            if (!query.trim()) {
                document.getElementById('searchResults').innerHTML = '';
                return;
            }

            fetch(`/api/songs/search?query=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(songs => {
                    const results = document.getElementById('searchResults');
                    results.innerHTML = songs.map(song => `
                        <div class="list-group-item list-group-item-action">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center">
                                       <img src="${(song.coverUrl)!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749381928/4a86344f69940e6b166c0bcbde36c3bc_om4gev.jpg'}"
                                         style="width: 40px; height: 40px; object-fit: cover;" 
                                         class="me-3 rounded">
                                    <div>
                                        <h6 class="mb-0">${song.title}</h6>
                                        <small class="text-muted">${song.artistName}</small>
                                    </div>
                                </div>
                                <button class="btn btn-primary btn-sm" onclick="addSong(${song.id})">
                                    <i class="bi bi-plus-lg"></i> Add
                                </button>
                            </div>
                        </div>
                    `).join('');
                });
        }

        function addSong(songId) {
            fetch(`/api/playlists/${playlist.id}/songs/${songId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(response => {
                if (response.ok) {
                    location.reload();
                }
            });
        }

        function removeSong(songId) {
            if (confirm('Remove this song from the playlist?')) {
                fetch(`/api/playlists/${playlist.id}/songs/${songId}`, {
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
</@base.page> 