# 🔧 Исправление CORS и настройка ngrok

## ❌ Текущая проблема

1. **ngrok настроен на порт 8080** (фронтенд) вместо 8000 (бэкенд)
2. **Фронтенд пытается обращаться к ngrok URL фронтенда** вместо бэкенда
3. **CORS ошибки**: `OPTIONS 501 Unsupported method`

## ✅ Решение

### Шаг 1: Запустите ngrok для бэкенда (Терминал 1)

```bash
ngrok http 8000
```

Запишите URL: `https://backend-abc123.ngrok-free.dev`

### Шаг 2: Запустите ngrok для фронтенда (Терминал 2)

```bash
ngrok http 8080
```

Запишите URL: `https://frontend-xyz789.ngrok-free.dev`

### Шаг 3: Пересоберите фронтенд с правильным URL бэкенда

```bash
cd "/Users/anymacstore/Flutter development/alien_tap"
flutter build web --dart-define=API_BASE_URL=https://backend-abc123.ngrok-free.dev
```

### Шаг 4: Перезапустите веб-сервер

```bash
cd build/web
python3 -m http.server 8080
```

### Шаг 5: Настройте Telegram бота

Используйте URL фронтенда: `https://frontend-xyz789.ngrok-free.dev`

---

## 🔍 Проверка CORS на бэкенде

CORS уже настроен в `src/main.rs`:

```rust
let cors = CorsLayer::new()
    .allow_origin(Any)
    .allow_methods([Method::GET, Method::POST, Method::OPTIONS])
    .allow_headers(Any);
```

Это должно работать. Если все еще есть ошибки, проверьте:

1. Бэкенд запущен: `curl http://localhost:8000/health`
2. ngrok для бэкенда работает: `curl https://backend-ngrok-url.ngrok-free.dev/health`

---

## 📋 Итоговая схема

```
Бэкенд:  localhost:8000  →  ngrok (терминал 1)  →  https://backend-url.ngrok-free.dev
Фронтенд: localhost:8080  →  ngrok (терминал 2)  →  https://frontend-url.ngrok-free.dev

Фронтенд использует: API_BASE_URL=https://backend-url.ngrok-free.dev
Telegram бот использует: https://frontend-url.ngrok-free.dev
```

---

**Удачи! 🚀**
