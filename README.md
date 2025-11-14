# 🎮 Alien Tap - Flutter Frontend

Flutter Web приложение для игры Alien Tap с интеграцией Telegram WebApp.

## 📋 Технологии

- **Flutter** 3.7.2+
- **Dart** 3.7.2+
- **MWWM** - Архитектурный паттерн
- **go_router** - Навигация
- **Dio** - HTTP клиент
- **GetStorage** - Локальное хранилище

## 🚀 Быстрый старт

### Локальная разработка

1. **Установите зависимости:**

   ```bash
   flutter pub get
   ```

2. **Запустите приложение:**
   ```bash
   flutter run -d chrome
   ```

### Тестирование с ngrok

Для тестирования в Telegram WebApp используйте ngrok:

1. **Запустите бэкенд:**

   ```bash
   cd ../alien_tap_backend
   cargo run
   ```

2. **Запустите ngrok:**

   ```bash
   ngrok http 8000
   ```

3. **Запустите Flutter с ngrok URL:**

   ```bash
   flutter run -d chrome --dart-define=API_BASE_URL=https://your-ngrok-url.ngrok-free.dev
   ```

   Или используйте скрипт:

   ```bash
   ./scripts/run_with_ngrok.sh
   ```

📖 **Подробная инструкция:** [NGROK_SETUP.md](NGROK_SETUP.md)

## 🔧 Конфигурация

### Переменные окружения

- `API_BASE_URL` - URL бэкенда (по умолчанию: `http://localhost:8000`)
- `PRODUCTION` - Флаг production окружения

### Примеры использования

```bash
# Development (локально)
flutter run -d chrome

# Development (с ngrok)
flutter run -d chrome --dart-define=API_BASE_URL=https://abc123.ngrok-free.dev

# Production
flutter run -d chrome --dart-define=API_BASE_URL=https://api.yourdomain.com --dart-define=PRODUCTION=true
```

## 📚 Документация

- [📖 Стратегия деплоя](DEPLOYMENT_STRATEGY.md) - Полное руководство по деплою
- [🔧 Настройка ngrok](NGROK_SETUP.md) - Работа с ngrok для локального тестирования
- [🏗️ Архитектура](ARCHITECTURE_GUIDE.md) - Описание архитектуры приложения
- [📡 API документация](FLUTTER_API_DOCS.md) - Документация API
- [📱 Экраны и flow](FLUTTER_SCREENS_AND_FLOW.md) - Описание экранов

## 🚢 Деплой

### Быстрый деплой

1. **Backend:** Задеплойте на [Railway](https://railway.app) или [Render](https://render.com)
2. **Frontend:** Задеплойте на [Vercel](https://vercel.com) или [Netlify](https://netlify.com)

📖 **Подробная инструкция:** [DEPLOYMENT_STRATEGY.md](DEPLOYMENT_STRATEGY.md)

## 🏗️ Структура проекта

```
lib/
├── app/              # Конфигурация приложения
│   ├── app.dart      # Главный виджет
│   ├── router/       # Роутинг
│   └── di/           # Dependency Injection
├── config/           # Конфигурация (окружения)
├── data/             # Данные (API, репозитории)
│   └── api/          # API клиент
└── features/         # Функциональные модули
    ├── tap_game/     # Игровой экран
    ├── leaderboard/  # Таблица лидеров
    └── claim/        # Вывод токенов
```

## 🔗 Связанные репозитории

- **Backend:** [alien-tap-backend](https://github.com/RomanDevelop/alien-tap-backend)

## 📝 Лицензия

MIT

---

**Удачи с разработкой! 🚀**
