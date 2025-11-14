# 🚀 Деплой на Vercel с ngrok бэкендом

## ⚠️ Текущая ситуация

- ✅ Фронтенд задеплоен на Vercel: `https://alien-tap-front.vercel.app`
- ✅ Бэкенд работает локально на `localhost:8000`
- ✅ ngrok туннель: `https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev -> http://localhost:8000`
- ❌ **Проблема:** Фронтенд пытается подключиться к `localhost:8000`, который недоступен из интернета

## ✅ Решение

### Вариант 1: Обновить Vercel с ngrok URL (быстро)

1. **Обновите `vercel.json`** с вашим ngrok URL:
   ```json
   {
     "buildCommand": "flutter build web --dart-define=API_BASE_URL=https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev",
     "outputDirectory": "build/web",
     "installCommand": "flutter pub get"
   }
   ```

2. **Закоммитьте и запушьте:**
   ```bash
   git add vercel.json
   git commit -m "Update Vercel config with ngrok backend URL"
   git push
   ```

3. **Vercel автоматически пересоберет проект** с новым URL

### Вариант 2: Использовать Environment Variables в Vercel (рекомендуется)

1. **В Vercel Dashboard:**
   - Settings → Environment Variables
   - Добавьте: `API_BASE_URL` = `https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev`

2. **Обновите `vercel.json`:**
   ```json
   {
     "buildCommand": "flutter build web --dart-define=API_BASE_URL=$API_BASE_URL",
     "outputDirectory": "build/web",
     "installCommand": "flutter pub get"
   }
   ```

3. **Закоммитьте и запушьте**

---

## ⚠️ Важно: ngrok URL меняется!

**Проблема:** При каждом перезапуске ngrok URL меняется (на бесплатном плане).

**Решения:**

### 🔴 Временное решение (для тестирования):
- Каждый раз при перезапуске ngrok обновляйте URL в Vercel

### ✅ Постоянное решение (рекомендуется):
**Задеплойте бэкенд на Railway!** Тогда URL будет постоянным.

См. [DEPLOY_BACKEND_FIRST.md](DEPLOY_BACKEND_FIRST.md)

---

## 🔄 Текущие шаги (с ngrok)

1. **Убедитесь, что ngrok запущен:**
   ```bash
   ngrok http 8000
   ```
   URL: `https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev`

2. **Убедитесь, что бэкенд запущен:**
   ```bash
   cd ../alien_tap_backend
   cargo run
   ```

3. **Обновите Vercel:**
   - Либо через `vercel.json` (уже создан)
   - Либо через Environment Variables в Vercel Dashboard

4. **Проверьте:**
   - Откройте: `https://alien-tap-front.vercel.app/#/auth`
   - Ошибка подключения должна исчезнуть

---

## 📋 Проверка работы

1. **Проверьте бэкенд через ngrok:**
   ```bash
   curl https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev/health
   ```

2. **Проверьте фронтенд:**
   - Откройте в браузере: `https://alien-tap-front.vercel.app/#/auth`
   - Попробуйте авторизоваться через Telegram

---

## 🎯 Итоговая схема

```
Бэкенд:  localhost:8000  →  ngrok  →  https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev
Фронтенд: Vercel  →  https://alien-tap-front.vercel.app

Фронтенд использует: API_BASE_URL=https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev
```

---

**⚠️ Помните:** При перезапуске ngrok URL изменится! Лучше задеплоить бэкенд на Railway.

