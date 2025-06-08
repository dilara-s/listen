<header class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="/">Listen</a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/songs">Песни</a>
                </li>
                <#if currentUser??>
                    <li class="nav-item">
                        <a class="nav-link" href="/chat">Чат</a>
                    </li>
                </#if>
                <li class="nav-item">
                    <a class="nav-link" href="/artists">Исполнители</a>
                </li>
            </ul>
            
            <div class="d-flex align-items-center">
                <#if currentUser??>
                    <div class="dropdown">
                        <button class="btn btn-link nav-link dropdown-toggle d-flex align-items-center" 
                                type="button" 
                                id="profileDropdown" 
                                data-bs-toggle="dropdown" 
                                aria-expanded="false">
                            <img src="${currentUser.avatarUrl!'https://res.cloudinary.com/dsyuw4byo/image/upload/v1734878648/user_image_kqyoma.png'}" 
                                 alt="${currentUser.username}" 
                                 class="rounded-circle"
                                 width="32" 
                                 height="32">
                            <span class="ms-2">${currentUser.username}</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                            <li><a class="dropdown-item" href="/profile/${currentUser.id}">Мой профиль</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <form action="/logout" method="POST" class="px-3">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-link text-danger p-0">Выйти</button>
                                </form>
                            </li>
                        </ul>
                    </div>
                <#else>
                    <a href="/login" class="btn btn-outline-light me-2">Войти</a>
                    <a href="/registration" class="btn btn-primary">Регистрация</a>
                </#if>
            </div>
        </div>
    </div>
</header> 