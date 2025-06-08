<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Доступ запрещен</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        .error-container {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        .error-content {
            max-width: 600px;
            padding: 2rem;
        }
        .error-code {
            font-size: 8rem;
            font-weight: bold;
            color: #ff4444;
            margin-bottom: 1rem;
        }
        .error-message {
            font-size: 1.5rem;
            margin-bottom: 2rem;
            color: #666;
        }
        .home-link {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4444ff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .home-link:hover {
            background-color: #3333cc;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-content">
            <div class="error-code">403</div>
            <div class="error-message">Доступ запрещен</div>
            <p>У вас нет прав для доступа к ресурсу: ${url!''}</p>
            <a href="/" class="home-link">Вернуться на главную</a>
        </div>
    </div>
</body>
</html> 