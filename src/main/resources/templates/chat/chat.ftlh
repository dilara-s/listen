<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Общий чат</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .chat-container {
            max-width: 800px;
            margin: 2rem auto;
            height: calc(100vh - 200px);
            display: flex;
            flex-direction: column;
        }
        
        .chat-messages {
            flex-grow: 1;
            overflow-y: auto;
            padding: 1rem;
            background-color: #f8f9fa;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .message {
            margin-bottom: 1rem;
            padding: 0.5rem 1rem;
            border-radius: 1rem;
            max-width: 70%;
        }
        
        .message.own {
            background-color: #007bff;
            color: white;
            margin-left: auto;
        }
        
        .message.other {
            background-color: #6c757d;
            color: white;
        }
        
        .message.system {
            background-color: #e9ecef;
            color: #6c757d;
            text-align: center;
            margin: 0.5rem auto;
            font-size: 0.9rem;
        }
        
        .message-input {
            display: flex;
            gap: 1rem;
            padding: 1rem;
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        .message-time {
            font-size: 0.8rem;
            opacity: 0.8;
        }
        
        .message-sender {
            font-weight: bold;
            margin-bottom: 0.25rem;
        }

        .online-users {
            background-color: white;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <#import "../base.ftlh" as base>
    <@base.page title="Общий чат">
    <div class="container">
        <div class="chat-container">
            <div class="chat-messages" id="chatMessages">
                <!-- Сообщения будут добавляться здесь -->
            </div>
            
            <div class="message-input">
                <input type="text" class="form-control" id="messageInput" placeholder="Введите сообщение...">
                <button class="btn btn-primary" onclick="sendMessage()">
                    <i class="bi bi-send"></i>
                </button>
            </div>
        </div>
    </div>

    <script>
        let webSocket;
        const username = '${username}';
        let onlineUsers = new Set();
        
        function connect() {
            webSocket = new WebSocket('ws://' + window.location.host + '/ws/chat');
            
            webSocket.onopen = function() {
                console.log('WebSocket соединение установлено');
                addSystemMessage('Соединение установлено');
            };
            
            webSocket.onmessage = function(event) {
                const message = JSON.parse(event.data);
                console.log('Получено сообщение:', message);
                
                // Обновляем список пользователей, если он есть в сообщении
                if (message.activeUsers) {
                    onlineUsers.clear();
                    message.activeUsers.forEach(user => onlineUsers.add(user));
                    updateOnlineCount();
                }
                
                displayMessage(message);
            };
            
            webSocket.onclose = function() {
                console.log('WebSocket соединение закрыто');
                addSystemMessage('Соединение закрыто');
                // Очищаем список пользователей
                onlineUsers.clear();
                updateOnlineCount();
                // Попытка переподключения через 5 секунд
                setTimeout(connect, 5000);
            };
            
            webSocket.onerror = function(error) {
                console.error('WebSocket ошибка:', error);
                addSystemMessage('Произошла ошибка соединения');
            };
        }
        
        function updateOnlineCount() {
            document.getElementById('onlineCount').textContent = onlineUsers.size;
        }
        
        function sendMessage() {
            const input = document.getElementById('messageInput');
            const content = input.value.trim();
            
            if (content && webSocket && webSocket.readyState === WebSocket.OPEN) {
                const message = {
                    content: content,
                    username: username,
                    timestamp: new Date().toISOString()
                };
                
                console.log('Отправка сообщения:', message);
                webSocket.send(JSON.stringify(message));
                input.value = '';
            }
        }
        
        function displayMessage(message) {
            console.log('Отображение сообщения:', message);
            const chatMessages = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            
            // Определяем, является ли сообщение системным по его содержанию
            const isSystemMessage = message.content.includes('присоединился к чату') || 
                                  message.content.includes('покинул чат');
            
            if (isSystemMessage) {
                messageDiv.className = 'message system';
                messageDiv.textContent = message.content;
            } else {
                const isOwnMessage = message.username === username;
                messageDiv.className = 'message ' + (isOwnMessage ? 'own' : 'other');
                
                const senderDiv = document.createElement('div');
                senderDiv.className = 'message-sender';
                senderDiv.textContent = message.username;
                
                const contentDiv = document.createElement('div');
                contentDiv.textContent = message.content;
                
                const timeDiv = document.createElement('div');
                timeDiv.className = 'message-time';
                // Форматируем время
                const messageTime = new Date(message.timestamp);
                const formattedTime = messageTime.toLocaleTimeString('ru-RU', {
                    hour: '2-digit',
                    minute: '2-digit'
                });
                timeDiv.textContent = formattedTime;
                
                messageDiv.appendChild(senderDiv);
                messageDiv.appendChild(contentDiv);
                messageDiv.appendChild(timeDiv);
            }
            
            chatMessages.appendChild(messageDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
        
        function addSystemMessage(content) {
            const message = {
                content: content,
                timestamp: new Date().toISOString()
            };
            displayMessage(message);
        }
        
        // Обработка нажатия Enter в поле ввода
        document.getElementById('messageInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
        
        // Подключаемся при загрузке страницы
        connect();
    </script>
    </@base.page>
</body>
</html> 