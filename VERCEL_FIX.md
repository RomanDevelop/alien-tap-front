# 🔧 Исправление деплоя на Vercel

## ❌ Проблема

Vercel не поддерживает Flutter напрямую - команда `flutter` не найдена в их окружении.

## ✅ Решение: GitHub Actions

Используем GitHub Actions для сборки Flutter и деплоя на Vercel.

### Шаг 1: Получите Vercel токены

1. **Войдите в Vercel Dashboard:**
   - https://vercel.com/account/tokens
   - Создайте новый токен: `VERCEL_TOKEN`

2. **Получите Project ID и Org ID:**
   - Откройте проект в Vercel
   - Settings → General
   - Скопируйте:
     - **Project ID** (например: `prj_xxxxx`)
     - **Organization ID** (например: `team_xxxxx`)

### Шаг 2: Настройте GitHub Secrets

1. **Откройте GitHub репозиторий:**
   - Settings → Secrets and variables → Actions

2. **Добавьте секреты:**
   ```
   VERCEL_TOKEN=your_vercel_token
   VERCEL_ORG_ID=your_org_id
   VERCEL_PROJECT_ID=your_project_id
   API_BASE_URL=https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev
   ```

### Шаг 3: Закоммитьте и запушьте

```bash
git add .github/workflows/deploy-vercel.yml vercel.json
git commit -m "Add GitHub Actions for Vercel deployment"
git push
```

GitHub Actions автоматически соберет и задеплоит проект!

---

## 🔄 Альтернатива: Собрать локально и задеплоить

Если не хотите использовать GitHub Actions:

### Вариант 1: Собрать локально и задеплоить через Vercel CLI

```bash
# 1. Соберите проект
flutter build web --dart-define=API_BASE_URL=https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev

# 2. Установите Vercel CLI
npm i -g vercel

# 3. Задеплойте
cd build/web
vercel --prod
```

### Вариант 2: Закоммитить build/web

1. **Соберите проект:**
   ```bash
   flutter build web --dart-define=API_BASE_URL=https://unhedonistically-nonpragmatical-deonna.ngrok-free.dev
   ```

2. **Закоммитьте build/web:**
   ```bash
   git add build/web
   git commit -m "Add built web files"
   git push
   ```

3. **Настройте Vercel:**
   - Root Directory: `build/web`
   - Build Command: (оставьте пустым)
   - Output Directory: `.`

---

## 🎯 Рекомендация

**Используйте GitHub Actions** - это автоматизирует процесс и не требует ручной сборки.

---

## ⚠️ Важно: ngrok URL меняется!

При перезапуске ngrok URL изменится. Обновите `API_BASE_URL` в GitHub Secrets.

**Лучше задеплойте бэкенд на Railway** - тогда URL будет постоянным!

См. [DEPLOY_BACKEND_FIRST.md](DEPLOY_BACKEND_FIRST.md)

