<#import "../base.ftlh" as base>
<#import "/spring.ftl" as spring>

<@base.page title="Artists">
    <div class="container py-5">
        <!-- Search and Filters -->
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="input-group">
                    <input type="text" 
                           class="form-control" 
                           id="searchInput" 
                           placeholder="Search artists..."
                           value="${query!''}"
                           onkeyup="debounceSearch(this.value)">
                    <button class="btn btn-outline-secondary" type="button">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>
            <div class="col-md-4">
                <select class="form-select" id="tagFilter" onchange="filterByTag(this.value)">
                    <option value="">All Genres</option>
                    <#if artists?? && artists?size gt 0>
                        <#list artists as artist>
                            <#list (artist.tags![]) as tag>
                                <option value="${tag}" <#if selectedTag?? && selectedTag == tag>selected</#if>>${tag}</option>
                            </#list>
                        </#list>
                    </#if>
                </select>
            </div>
        </div>

        <!-- Artists Grid -->
        <div class="row g-4" id="artistsGrid">
            <#list artists as artist>
                <div class="col-sm-6 col-md-4 col-lg-3">
                    <div class="card h-100 artist-card">
                        <div class="position-relative">
                            <img src="${(artist.imageUrl?? && artist.imageUrl != '')?then(artist.imageUrl, 'https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg')}" 
                                 class="card-img-top" 
                                 alt="${artist.name}"
                                 style="height: 250px; object-fit: cover;"
                                 onerror="this.src='https://res.cloudinary.com/dsyuw4byo/image/upload/v1749376033/cd1a3129e2f329c1606058abb2e369b0_prpkac.jpg'">
                            <div class="position-absolute bottom-0 start-0 w-100 p-3" 
                                 style="background: linear-gradient(transparent, rgba(0,0,0,0.8));">
                                <h5 class="card-title mb-0">
                                    <a href="/artists/${artist.name}" class="text-white text-decoration-none">
                                        ${artist.name}
                                    </a>
                                </h5>
                            </div>
                        </div>
                        <div class="card-body">
                            <#if artist.biography??>
                                <p class="card-text text-muted small">
                                    ${artist.biography?truncate(100)}
                                </p>
                            </#if>
                            <div class="tags mb-2">
                                <#assign tags = artist.tags![]>
                                <#list tags as tag>
                                    <#if tag?counter <= 3>
                                        <span class="badge bg-secondary me-1">
                                            <a href="?tag=${tag}" class="text-white text-decoration-none">
                                                ${tag}
                                            </a>
                                        </span>
                                    </#if>
                                </#list>
                                <#if tags?size gt 3>
                                    <span class="badge bg-secondary">+${tags?size - 3}</span>
                                </#if>
                            </div>
                        </div>
                    </div>
                </div>
            <#else>
                <div class="col-12 text-center py-5">
                    <i class="bi bi-person-x display-1 text-muted"></i>
                    <h3 class="mt-3">No artists found</h3>
                    <p class="text-muted">Try different search terms or filters</p>
                </div>
            </#list>
        </div>
    </div>

    <style>
        .artist-card {
            transition: transform 0.2s;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .artist-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .tags .badge {
            transition: background-color 0.2s;
        }
        .tags .badge:hover {
            background-color: var(--bs-primary) !important;
        }
    </style>

    <script>
        let searchTimeout;

        function debounceSearch(query) {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                window.location.href = '/artists' + (query ? '?query=' + encodeURIComponent(query) : '');
            }, 300);
        }

        function filterByTag(tag) {
            window.location.href = '/artists' + (tag ? '?tag=' + encodeURIComponent(tag) : '');
        }
    </script>
</@base.page> 