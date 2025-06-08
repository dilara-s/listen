<#import "base.ftlh" as base>

<@base.page title="Listen - Your Music Streaming Service">
    <div class="container">
        <div class="row min-vh-100 align-items-center justify-content-center">
            <div class="col-md-8 text-center">
                <h1 class="display-2 mb-4">Welcome to Listen</h1>
                <p class="lead mb-5">Your personal music streaming service. Discover, share, and enjoy your favorite music.</p>
                
                <div class="row justify-content-center g-4">
                    <div class="col-md-4">
                        <div class="card h-100 border-0 shadow-sm">
                            <div class="card-body text-center">
                                <i class="bi bi-music-note-list display-4 text-primary mb-3"></i>
                                <h3 class="h4">Browse Songs</h3>
                                <p class="text-muted">Explore our vast collection of music</p>
                                <a href="/songs" class="btn btn-outline-primary">Go to Songs</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card h-100 border-0 shadow-sm">
                            <div class="card-body text-center">
                                <i class="bi bi-collection-play display-4 text-primary mb-3"></i>
                                <h3 class="h4">Create Playlists</h3>
                                <p class="text-muted">Organize your music into playlists</p>
                                <a href="/profile/${user.id}/playlists" class="btn btn-outline-primary">My Playlists</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</@base.page> 