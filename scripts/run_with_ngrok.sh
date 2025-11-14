#!/bin/bash

# Скрипт для запуска Flutter Web с ngrok URL
# Использование: ./scripts/run_with_ngrok.sh

set -e

echo "🔍 Проверка ngrok..."

# Проверяем, запущен ли ngrok
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[^"]*\.ngrok[^"]*' | head -1)

if [ -z "$NGROK_URL" ]; then
  echo "❌ ngrok не запущен!"
  echo ""
  echo "📝 Инструкция:"
  echo "1. Запустите бэкенд: cd ../alien_tap_backend && cargo run"
  echo "2. В другом терминале запустите: ngrok http 8000"
  echo "3. Затем запустите этот скрипт снова"
  exit 1
fi

echo "✅ Найден ngrok URL: $NGROK_URL"
echo ""
echo "🚀 Запуск Flutter Web с ngrok..."
echo ""

# Запускаем Flutter с ngrok URL
flutter run -d chrome --dart-define=API_BASE_URL="$NGROK_URL"

