<#import "../base.ftlh" as base>

<@base.page title="Вход - Listen">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">Вход в систему</h4>
                    </div>
                    <div class="card-body">
                        <#if error??>
                            <div class="alert alert-danger">
                                ${error}
                            </div>
                        </#if>
                        
                        <#if message??>
                            <div class="alert alert-success">
                                ${message}
                            </div>
                        </#if>

                        <form action="/login" method="POST">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <div class="mb-3">
                                <label for="username" class="form-label">Имя пользователя</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="username" 
                                       name="username" 
                                       required 
                                       autofocus>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Пароль</label>
                                <input type="password" 
                                       class="form-control" 
                                       id="password" 
                                       name="password" 
                                       required>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">
                                    Войти
                                </button>
                            </div>
                        </form>

                        <div class="mt-3 text-center">
                            <p>Нет аккаунта? <a href="/registration">Зарегистрироваться</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</@base.page> 