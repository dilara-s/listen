class ChatWebSocket {
    constructor() {
        this.socket = null;
        this.messageContainer = document.querySelector('.chat-messages');
        this.messageInput = document.querySelector('.chat-input input');
        this.sendButton = document.querySelector('.chat-input button');
        
        this.connect();
        this.initializeEventListeners();
    }

    connect() {
        // Get the user token from a meta tag or other secure storage
        const token = document.querySelector('meta[name="user-token"]')?.content;
        
        this.socket = new WebSocket(`ws://${window.location.host}/ws/chat?token=${token}`);

        this.socket.onopen = () => {
            console.log('WebSocket connection established');
            this.showConnectionStatus(true);
        };

        this.socket.onclose = () => {
            console.log('WebSocket connection closed');
            this.showConnectionStatus(false);
            // Try to reconnect after 5 seconds
            setTimeout(() => this.connect(), 5000);
        };

        this.socket.onerror = (error) => {
            console.error('WebSocket error:', error);
            this.showConnectionStatus(false);
        };

        this.socket.onmessage = (event) => {
            const message = JSON.parse(event.data);
            this.displayMessage(message);
        };
    }

    initializeEventListeners() {
        // Send message on button click
        this.sendButton?.addEventListener('click', () => this.sendMessage());

        // Send message on Enter key
        this.messageInput?.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                this.sendMessage();
            }
        });
    }

    sendMessage() {
        if (!this.messageInput?.value.trim()) return;

        const message = {
            content: this.messageInput.value,
            timestamp: new Date().toISOString()
        };

        try {
            this.socket.send(JSON.stringify(message));
            this.messageInput.value = '';
        } catch (error) {
            console.error('Error sending message:', error);
            this.showError('Failed to send message. Please try again.');
        }
    }

    displayMessage(message) {
        const messageElement = document.createElement('div');
        messageElement.className = `message ${message.isSentByCurrentUser ? 'message-sent' : 'message-received'}`;

        const contentElement = document.createElement('div');
        contentElement.className = 'message-content';
        contentElement.textContent = message.content;

        const timeElement = document.createElement('div');
        timeElement.className = 'message-time';
        timeElement.textContent = this.formatTime(new Date(message.timestamp));

        const userElement = document.createElement('div');
        userElement.className = 'message-user';
        userElement.textContent = message.username;

        messageElement.appendChild(userElement);
        messageElement.appendChild(contentElement);
        messageElement.appendChild(timeElement);

        this.messageContainer?.appendChild(messageElement);
        this.scrollToBottom();
    }

    showConnectionStatus(isConnected) {
        const statusElement = document.querySelector('.chat-status');
        if (statusElement) {
            statusElement.textContent = isConnected ? 'Connected' : 'Disconnected';
            statusElement.className = `chat-status ${isConnected ? 'connected' : 'disconnected'}`;
        }
    }

    showError(message) {
        const errorElement = document.createElement('div');
        errorElement.className = 'alert alert-error';
        errorElement.textContent = message;

        const chatContainer = document.querySelector('.chat-container');
        chatContainer?.insertBefore(errorElement, chatContainer.firstChild);

        setTimeout(() => errorElement.remove(), 5000);
    }

    scrollToBottom() {
        if (this.messageContainer) {
            this.messageContainer.scrollTop = this.messageContainer.scrollHeight;
        }
    }

    formatTime(date) {
        return date.toLocaleTimeString('en-US', {
            hour: '2-digit',
            minute: '2-digit'
        });
    }
}

// Initialize chat when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    if (document.querySelector('.chat-container')) {
        const chat = new ChatWebSocket();
    }
}); 