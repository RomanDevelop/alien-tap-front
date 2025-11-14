#!/bin/bash

# Скрипт для сборки и деплоя на Vercel
# Использование: ./scripts/deploy_to_vercel.sh [API_BASE_URL]

set -e

# Получаем API_BASE_URL из аргумента или используем ngrok URL
API_BASE_URL=${1:-"https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev"}

echo "🔨 Сборка Flutter Web с API_BASE_URL=$API_BASE_URL..."

# Собираем проект
flutter build web --dart-define=API_BASE_URL="$API_BASE_URL"

echo ""
echo "✅ Сборка завершена!"
echo ""
echo "📦 Деплой на Vercel..."

# Проверяем, установлен ли Vercel CLI
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI не установлен!"
    echo ""
    echo "📝 Установите Vercel CLI:"
    echo "   npm i -g vercel"
    echo ""
    echo "Или используйте GitHub Actions (см. VERCEL_FIX.md)"
    exit 1
fi

# Переходим в директорию с собранными файлами
cd build/web

# Деплоим на Vercel
vercel --prod

echo ""
echo "✅ Деплой завершен!"

