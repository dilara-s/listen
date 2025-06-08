<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="Edit Profile">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Edit Profile</h4>
                    </div>
                    <div class="card-body">
                        <form action="/profile/edit" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <div class="mb-3 text-center">
                                <img src="${user.avatarUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1734878648/user_image_kqyoma.png'}" 
                                     class="rounded-circle img-thumbnail mb-3" 
                                     style="width: 150px; height: 150px; object-fit: cover;" 
                                     alt="Current avatar"
                                     id="avatarPreview">
                            </div>

                            <div class="mb-3">
                                <label for="avatar" class="form-label">Change Avatar</label>
                                <input type="file" 
                                       class="form-control" 
                                       id="avatar" 
                                       name="avatar"
                                       accept="image/*"
                                       onchange="previewAvatar(this)">
                            </div>
                            
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="username" 
                                       name="username" 
                                       value="${user.username}" 
                                       required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" 
                                       class="form-control" 
                                       id="email" 
                                       name="email" 
                                       value="${user.email}" 
                                       required>
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <a href="/profile" class="btn btn-outline-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    document.getElementById('avatarPreview').src = e.target.result;
                }
                
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</@base.page> 