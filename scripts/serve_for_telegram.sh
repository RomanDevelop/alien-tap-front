#!/bin/bash

# Скрипт для запуска Flutter Web для Telegram WebApp
# Использование: ./scripts/serve_for_telegram.sh

set -e

echo "🔍 Проверка ngrok для бэкенда..."

# Проверяем, запущен ли ngrok для бэкенда
BACKEND_NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[^"]*\.ngrok[^"]*' | grep -v 'ngrok-free.dev' | head -1)

if [ -z "$BACKEND_NGROK_URL" ]; then
  # Пробуем найти любой ngrok URL
  BACKEND_NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[^"]*\.ngrok[^"]*' | head -1)
fi

if [ -z "$BACKEND_NGROK_URL" ]; then
  echo "⚠️  ngrok для бэкенда не найден!"
  echo ""
  echo "📝 Инструкция:"
  echo "1. Запустите бэкенд: cd ../alien_tap_backend && cargo run"
  echo "2. В другом терминале запустите: ngrok http 8000"
  echo "3. Затем запустите этот скрипт снова"
  echo ""
  read -p "Продолжить с localhost:8000? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
  BACKEND_NGROK_URL="http://localhost:8000"
else
  echo "✅ Найден ngrok URL для бэкенда: $BACKEND_NGROK_URL"
fi

echo ""
echo "🔨 Сборка Flutter Web..."
flutter build web --dart-define=API_BASE_URL="$BACKEND_NGROK_URL"

echo ""
echo "🌐 Запуск веб-сервера на порту 8080..."
echo "📝 Теперь запустите ngrok для фронтенда в другом терминале:"
echo "   ngrok http 8080"
echo ""
echo "⚠️  После запуска ngrok скопируйте HTTPS URL и настройте его в @BotFather"
echo ""

cd build/web
python3 -m http.server 8080

