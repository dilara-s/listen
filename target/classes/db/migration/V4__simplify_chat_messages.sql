-- Удаляем старые колонки
ALTER TABLE chat_messages
    DROP COLUMN IF EXISTS user_id,
    DROP COLUMN IF EXISTS type,
    DROP COLUMN IF EXISTS shared_song_id,
    DROP COLUMN IF EXISTS shared_playlist_id; 