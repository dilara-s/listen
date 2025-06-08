<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="${user.username}'s Playlists">
    <div class="container py-5">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-0">${user.username}'s Playlists</h2>
                <p class="text-muted">
                    <#if playlists?size == 1>
                        1 playlist
                    <#else>
                        ${playlists?size} playlists
                    </#if>
                </p>
            </div>
            <#if currentUser?? && currentUser.id == user.id>
                <a href="/playlists/create" class="btn btn-outline-primary">
                    <i class="bi bi-plus-lg"></i> Create New Playlist
                </a>
            </#if>
        </div>

        <!-- Playlists Grid -->
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <#if playlists?? && playlists?size gt 0>
                <#list playlists as playlist>
                    <div class="col">
                        <a href="/playlists/${playlist.id}" class="text-decoration-none">
                            <div class="card h-100">
                                <img src="${playlist.coverUrl!'https://via.placeholder.com/300'}" 
                                     class="card-img-top" 
                                     alt="${playlist.title}"
                                     style="height: 200px; object-fit: cover;">
                                <div class="card-body">
                                    <h5 class="card-title text-dark">${playlist.title}</h5>
                                    <p class="card-text text-muted">
                                        ${playlist.songs?size} songs
                                    </p>
                                    <p class="card-text text-dark">
                                        ${(playlist.description!'No description')?truncate(100)}
                                    </p>
                                </div>
                            </div>
                        </a>
                    </div>
                </#list>
            <#else>
                <div class="col-12 text-center py-5">
                    <i class="bi bi-collection-play display-1 text-muted"></i>
                    <h3 class="mt-3">No playlists yet</h3>
                    <#if currentUser?? && currentUser.id == user.id>
                        <p class="text-muted">Create your first playlist to start organizing your music!</p>
                        <a href="/playlists/create" class="btn btn-primary mt-3">
                            <i class="bi bi-plus-lg"></i> Create New Playlist
                        </a>
                    <#else>
                        <p class="text-muted">This user hasn't created any playlists yet.</p>
                    </#if>
                </div>
            </#if>
        </div>
    </div>
</@base.page> 