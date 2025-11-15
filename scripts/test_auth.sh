#!/bin/bash

# Скрипт для тестирования эндпоинта авторизации с мок-данными
# Использование: ./scripts/test_auth.sh [backend_url]

set -e

# Получаем URL бэкенда из аргумента или ngrok
BACKEND_URL=${1:-""}

if [ -z "$BACKEND_URL" ]; then
  # Пробуем найти ngrok URL
  BACKEND_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[^"]*\.ngrok[^"]*' | head -1)
  
  if [ -z "$BACKEND_URL" ]; then
    BACKEND_URL="http://localhost:8000"
    echo "⚠️  ngrok не найден, используем localhost:8000"
  else
    echo "✅ Найден ngrok URL: $BACKEND_URL"
  fi
fi

echo ""
echo "🧪 Тестирование эндпоинта /auth/telegram"
echo "📍 URL: $BACKEND_URL"
echo ""

# Тест 1: Запрос с полным набором данных (включая user)
echo "📤 Тест 1: Запрос с полным набором данных (hash, auth_date, user)"
echo "─────────────────────────────────────────────────────────────"

RESPONSE=$(curl -s -X POST "$BACKEND_URL/auth/telegram" \
  -H "Content-Type: application/json" \
  -H "ngrok-skip-browser-warning: true" \
  -d '{
    "hash": "163798c5cc8c7c27d2ee55dd98b8ed6a8edaedd757b4cead2bf4dad1c632c121",
    "auth_date": 1763228561,
    "user": {
      "id": 123456789,
      "username": "test_user",
      "first_name": "Test",
      "last_name": "User"
    }
  }' \
  -w "\nHTTP_CODE:%{http_code}")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

echo "Ответ: $BODY"
echo "HTTP код: $HTTP_CODE"
echo ""

# Тест 2: Запрос БЕЗ поля user (для проверки валидации)
echo "📤 Тест 2: Запрос БЕЗ поля user (должна быть ошибка)"
echo "─────────────────────────────────────────────────────────────"

RESPONSE2=$(curl -s -X POST "$BACKEND_URL/auth/telegram" \
  -H "Content-Type: application/json" \
  -H "ngrok-skip-browser-warning: true" \
  -d '{
    "hash": "163798c5cc8c7c27d2ee55dd98b8ed6a8edaedd757b4cead2bf4dad1c632c121",
    "auth_date": 1763228561
  }' \
  -w "\nHTTP_CODE:%{http_code}")

HTTP_CODE2=$(echo "$RESPONSE2" | grep "HTTP_CODE:" | cut -d: -f2)
BODY2=$(echo "$RESPONSE2" | grep -v "HTTP_CODE:")

echo "Ответ: $BODY2"
echo "HTTP код: $HTTP_CODE2"
echo ""

# Тест 3: Запрос с user но без id
echo "📤 Тест 3: Запрос с user но БЕЗ id (должна быть ошибка)"
echo "─────────────────────────────────────────────────────────────"

RESPONSE3=$(curl -s -X POST "$BACKEND_URL/auth/telegram" \
  -H "Content-Type: application/json" \
  -H "ngrok-skip-browser-warning: true" \
  -d '{
    "hash": "163798c5cc8c7c27d2ee55dd98b8ed6a8edaedd757b4cead2bf4dad1c632c121",
    "auth_date": 1763228561,
    "user": {
      "username": "test_user",
      "first_name": "Test"
    }
  }' \
  -w "\nHTTP_CODE:%{http_code}")

HTTP_CODE3=$(echo "$RESPONSE3" | grep "HTTP_CODE:" | cut -d: -f2)
BODY3=$(echo "$RESPONSE3" | grep -v "HTTP_CODE:")

echo "Ответ: $BODY3"
echo "HTTP код: $HTTP_CODE3"
echo ""

echo "✅ Тестирование завершено!"
echo ""
echo "📋 Ожидаемые результаты:"
echo "   - Тест 1: HTTP 401 (Invalid telegram signature) - это нормально для мок-данных"
echo "   - Тест 2: HTTP 400 (Missing user field)"
echo "   - Тест 3: HTTP 400 (Missing user.id)"

