<#import "../base.ftlh" as base>

<@base.page title="Регистрация - Listen">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Регистрация</h4>
                    </div>
                    <div class="card-body">
                        <#if error??>
                            <div class="alert alert-danger">
                                ${error}
                            </div>
                        </#if>

                        <form action="/registration" method="POST" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label for="username" class="form-label">Имя пользователя</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="username" 
                                       name="username" 
                                       value="${(userRegistrationDto.username)!''}"
                                       required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" 
                                       class="form-control" 
                                       id="email" 
                                       name="email"
                                       value="${(userRegistrationDto.email)!''}"
                                       required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Пароль</label>
                                <input type="password" 
                                       class="form-control" 
                                       id="password" 
                                       name="password" 
                                       required>
                            </div>

                            <div class="mb-3">
                                <label for="avatar" class="form-label">Аватар (необязательно)</label>
                                <input type="file" 
                                       class="form-control" 
                                       id="avatar" 
                                       name="avatar"
                                       accept="image/*">
                            </div>

                            <div class="mb-3">
                                <label for="adminCode" class="form-label">Код администратора (необязательно)</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="adminCode" 
                                       name="adminCode"
                                       placeholder="Оставьте пустым, если не требуется">
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    Зарегистрироваться
                                </button>
                            </div>
                        </form>

                        <div class="mt-3 text-center">
                            <p>Уже есть аккаунт? <a href="/login">Войти</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</@base.page> 