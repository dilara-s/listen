<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="${user.username}'s Profile">
    <div class="container py-5">
        <!-- Profile Header -->
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body text-center">
                        <img src="${user.avatarUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1734878648/user_image_kqyoma.png'}" 
                             class="rounded-circle img-thumbnail mb-3" 
                             style="width: 150px; height: 150px; object-fit: cover;" 
                             alt="${user.username}'s avatar">
                        <h3>${user.username}</h3>
                        <p class="text-muted">${user.email}</p>

                        <#if currentUser?? && currentUser.id == user.id>
                            <div class="d-grid gap-2 col-md-6 mx-auto">
                                <a href="/profile/edit" class="btn btn-outline-primary">
                                    <i class="bi bi-pencil-fill"></i> Edit Profile
                                </a>
                                <a href="/profile/${user.id}/favorites" class="btn btn-outline-primary">
                                    <i class="bi bi-heart-fill"></i> Favorite Songs
                                </a>
                                <a href="/profile/${user.id}/playlists" class="btn btn-outline-primary">
                                    <i class="bi bi-music-note-list"></i> Playlists
                                </a>
                                <button type="button" 
                                        class="btn btn-outline-danger" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#deleteAccountModal">
                                    <i class="bi bi-trash"></i> Delete Account
                                </button>
                            </div>
                        </#if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Account Modal -->
    <#if currentUser?? && currentUser.id == user.id>
        <div class="modal fade" id="deleteAccountModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Delete Account</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete your account? This action cannot be undone.</p>
                        <p class="text-danger">All your playlists and data will be permanently deleted.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form action="/profile/delete" method="POST" style="display: inline;">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="btn btn-danger">Delete Account</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </#if>
</@base.page> 