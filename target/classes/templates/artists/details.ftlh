<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="${artist.name}">
    <div class="container py-5">
        <!-- Artist Header -->
        <div class="row mb-5">
            <div class="col-md-4">
                <img src="${artist.imageUrl!'https://via.placeholder.com/400'}" 
                     class="img-fluid rounded shadow" 
                     alt="${artist.name}"
                     style="width: 100%; height: 400px; object-fit: cover;">
            </div>
            <div class="col-md-8">
                <h1 class="display-4 mb-3">${artist.name}</h1>
                
                <!-- Tags -->
                <div class="mb-4">
                    <#list (artist.tags![]) as tag>
                        <a href="/artists?tag=${tag}" class="badge bg-secondary text-decoration-none me-2 mb-2">
                            ${tag}
                        </a>
                    </#list>
                </div>

                <!-- Biography -->
                <div class="mb-4">
                    <#if artist.biography??>
                        <p class="lead">${artist.biography}</p>
                    </#if>
                </div>

                <!-- Last.fm Link -->
                <#if artist.lastfmUrl??>
                    <a href="${artist.lastfmUrl}" target="_blank" class="btn btn-outline-danger mb-4">
                        <i class="bi bi-music-note"></i> View on Last.fm
                    </a>
                </#if>
            </div>
        </div>

        <div class="row">
            <!-- Similar Artists -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Similar Artists</h4>
                    </div>
                    <div class="card-body">
                        <#if artist.similarArtists?? && artist.similarArtists?size gt 0>
                            <div class="row g-3">
                                <#list artist.similarArtists as similarArtist>
                                    <div class="col-6">
                                        <a href="/artists/${similarArtist}" class="text-decoration-none">
                                            <div class="d-flex align-items-center p-2 border rounded hover-shadow">
                                                <i class="bi bi-person-circle fs-4 me-2"></i>
                                                <span class="text-truncate">${similarArtist}</span>
                                            </div>
                                        </a>
                                    </div>
                                </#list>
                            </div>
                        <#else>
                            <p class="text-muted mb-0">No similar artists found</p>
                        </#if>
                    </div>
                </div>
            </div>

            <!-- Songs -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Songs</h4>
                    </div>
                    <div class="card-body p-0">
                        <#if songs?? && songs?size gt 0>
                            <div class="list-group list-group-flush">
                                <#list songs as song>
                                    <div class="list-group-item">
                                        <div class="d-flex align-items-center">
                                            <img src="${song.coverUrl!'https://via.placeholder.com/40'}" 
                                                 class="rounded me-3" 
                                                 alt="${song.title}"
                                                 style="width: 40px; height: 40px; object-fit: cover;">
                                            <div class="flex-grow-1">
                                                <h6 class="mb-0">${song.title}</h6>
                                                <small class="text-muted">${song.duration!'--:--'}</small>
                                            </div>
                                            <button class="btn btn-link" onclick="playSong(${song.id})">
                                                <i class="bi bi-play-circle"></i>
                                            </button>
                                        </div>
                                    </div>
                                </#list>
                            </div>
                        <#else>
                            <p class="text-muted p-3 mb-0">No songs available</p>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .hover-shadow:hover {
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            background-color: var(--bs-light);
        }
    </style>

    <script>
        function playSong(songId) {
            // TODO: Implement play functionality
            console.log('Playing song:', songId);
        }
    </script>
</@base.page> 