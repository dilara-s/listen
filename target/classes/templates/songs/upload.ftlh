<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="Upload Song">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Upload New Song</h4>
                    </div>
                    <div class="card-body">
                        <form id="uploadForm" onsubmit="handleSubmit(event)">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <div class="position-relative">
                                            <img src="https://via.placeholder.com/400" 
                                                 id="coverPreview"
                                                 class="img-fluid rounded" 
                                                 alt="Song cover">
                                            <label for="coverFile" 
                                                   class="position-absolute top-50 start-50 translate-middle btn btn-light">
                                                <i class="bi bi-camera"></i> Choose Cover
                                            </label>
                                            <input type="file" 
                                                   class="d-none" 
                                                   id="coverFile" 
                                                   accept="image/*"
                                                   onchange="previewCover(this)">
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="audioFile" class="form-label">Audio File</label>
                                        <input type="file" 
                                               class="form-control" 
                                               id="audioFile" 
                                               accept="audio/*"
                                               required>
                                    </div>
                                </div>
                                <div class="col-md-8">
                                    <div class="mb-3">
                                        <label for="title" class="form-label">Title</label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="title" 
                                               name="title" 
                                               required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="artistName" class="form-label">Artist Name</label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="artistName" 
                                               name="artistName" 
                                               required>
                                    </div>
                                </div>
                            </div>
                            
                            <hr class="my-4">
                            
                            <div class="d-flex justify-content-between">
                                <a href="/songs" class="btn btn-outline-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary" id="submitBtn">
                                    Upload Song
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function previewCover(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('coverPreview').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        async function handleSubmit(event) {
            event.preventDefault();
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Uploading...';

            const csrfToken = document.querySelector('input[name="${_csrf.parameterName}"]').value;

            try {
                // Upload cover image
                const coverFile = document.getElementById('coverFile').files[0];
                let coverUrl = '';
                if (coverFile) {
                    const coverFormData = new FormData();
                    coverFormData.append('file', coverFile);
                    const coverResponse = await fetch('/api/songs/files/cover', {
                        method: 'POST',
                        headers: {
                            'X-CSRF-TOKEN': csrfToken
                        },
                        body: coverFormData
                    });
                    if (coverResponse.status === 403) {
                        throw new Error('У вас нет прав для загрузки песен. Только администраторы могут загружать песни.');
                    }
                    if (!coverResponse.ok) {
                        const errorText = await coverResponse.text();
                        throw new Error('Ошибка загрузки обложки: ' + errorText);
                    }
                    coverUrl = await coverResponse.text();
                }

                // Upload audio file
                const audioFile = document.getElementById('audioFile').files[0];
                const audioFormData = new FormData();
                audioFormData.append('file', audioFile);
                const audioResponse = await fetch('/api/songs/files/audio', {
                    method: 'POST',
                    headers: {
                        'X-CSRF-TOKEN': csrfToken
                    },
                    body: audioFormData
                });
                if (audioResponse.status === 403) {
                    throw new Error('У вас нет прав для загрузки песен. Только администраторы могут загружать песни.');
                }
                if (!audioResponse.ok) {
                    const errorText = await audioResponse.text();
                    throw new Error('Ошибка загрузки аудио: ' + errorText);
                }
                const audioUrl = await audioResponse.text();

                // Create song
                const songData = {
                    title: document.getElementById('title').value,
                    artistName: document.getElementById('artistName').value,
                    coverUrl: coverUrl || 'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg',
                    audioUrl: audioUrl
                };

                const response = await fetch('/api/songs', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': csrfToken
                    },
                    body: JSON.stringify(songData)
                });

                if (response.status === 403) {
                    throw new Error('У вас нет прав для создания песен. Только администраторы могут создавать песни.');
                }
                if (!response.ok) {
                    const errorData = await response.json();
                    throw new Error(errorData.message || 'Ошибка создания песни');
                }

                window.location.href = '/songs';
            } catch (error) {
                console.error('Error:', error);
                submitBtn.disabled = false;
                submitBtn.innerHTML = 'Upload Song';
                alert(error.message || 'Произошла ошибка при загрузке песни');
            }
        }
    </script>
</@base.page> 