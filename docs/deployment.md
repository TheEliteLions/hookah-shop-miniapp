# Настройка Supabase и Cloudflare Pages

## Supabase

1. В Supabase Dashboard убедитесь, что выбран целевой проект, и сверяйте его project ref с URL/настройками приложения. Сохраните database password в менеджере секретов; не передавайте её frontend.
2. Установите CLI и выполните `supabase login`. Свяжите локальную папку с проверенным ref командой `supabase link --project-ref <project-ref>`; эта команда записывает локальную привязку.
3. Перед изменениями выполните read-only проверки: `supabase migration list --linked` и запросы `SELECT` к `information_schema.tables`, `information_schema.columns` и `supabase_migrations.schema_migrations` через `supabase db query --linked`. Проверьте, что project ref/URL и имя проекта совпадают с выбранным проектом в Dashboard.
4. Просмотрите все SQL-файлы в `supabase/migrations/`, затем подготовьте план: `supabase db push --dry-run --linked`. Сверьте перечисленные миграции и историю с ожидаемым состоянием. Dry-run ничего не применяет; для `db push` требуется авторизация и database password.
5. Применяйте миграции через `supabase db push` только после отдельной проверки dry-run и явного подтверждения владельца. Локально `supabase db start` применяет миграцию и `supabase/seed.sql`; seed использует `ON CONFLICT DO NOTHING` и не обновляет/не удаляет существующие товары. Для production запускайте seed только после проверки схемы и отдельного разрешения владельца.
6. В Dashboard Auth → Sign In / Providers отключите `Allow new users to sign up` в production до privacy review. UI toggle сам по себе не защищает публичный Auth endpoint; серверная настройка Supabase является обязательной. Для локальной разработки можно временно включить регистрацию. В Auth настройте Site URL на фактический HTTPS Pages URL и allowlist для него и локального `http://localhost:5173`. Оставьте email confirmation включённым и настройте почтовую доставку. Redirect для recovery также должен попадать на `VITE_SITE_URL`.
7. Положите URL проекта и publishable key в `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`; никогда не добавляйте `service_role`.
8. Назначьте владельца админом по `docs/admin-bootstrap.md`. Проверьте доступы через тесты и реальный второй обычный аккаунт.
9. Локально запускайте SQL тесты командами `supabase db start` и `supabase test db`. GitHub workflow повторяет эти шаги на push/PR. До публикации этой инструкции workflow для commit `7473bdf` завершился ошибкой на `supabase test db`; результат pgTAP не подтверждён. Для разбора лога нужен GitHub-доступ с правами администратора репозитория.

## Cloudflare Pages

Выберите Vite framework preset или manual: install command `npm ci`, build command `npm run build`, output directory `dist`. Настройте production variables с теми же безопасными public values; установите `VITE_SITE_URL` в реальный URL. Публичный signup оставьте false до privacy review. Добавьте домен Pages в Supabase Auth redirect allowlist. При Git integration Cloudflare сам запускает деплой на push в `main`. GitHub Actions workflow `.github/workflows/cloudflare-pages.yml` оставлен для ручного деплоя (`workflow_dispatch`), чтобы не создавать два параллельных production deployment на каждый push. Для ручного workflow задайте GitHub repository variables `CLOUDFLARE_PAGES_PROJECT`, `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`, `VITE_SITE_URL`, `VITE_PUBLIC_SIGNUP_ENABLED` и secrets `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`.

Для GitHub Actions workflow `.github/workflows/cloudflare-pages.yml` нужны repository secrets `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID` и variable `CLOUDFLARE_PAGES_PROJECT`. Production deployment пока не запускался.

## Android

Workflow `android-apk.yml` запускается вручную после появления production URL: задайте Actions variable `WEB_APP_URL` равной HTTPS Pages URL. Он публикует debug APK как GitHub Actions artifact. Это тестовая debug сборка, не подписанный Google Play release. Для Play Store владелец отдельно организует signing key и безопасные secrets.

## Тарифы и официальные инструкции

Перед реальным запуском повторно проверьте текущие лимиты и бесплатный тариф на официальных страницах Supabase, Cloudflare Pages и Android WebView. Бесплатный план не является гарантией uptime/SLA; демо без настроенной почты не подтверждает работоспособность confirmation flow.

- [Supabase Auth configuration](https://supabase.com/docs/guides/auth/general-configuration)
- [Supabase RLS, grants and policies](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Supabase Storage access control](https://supabase.com/docs/guides/storage/security/access-control)
- [Cloudflare Pages limits](https://developers.cloudflare.com/pages/platform/limits/)
- [Android WebView guide](https://developer.android.com/develop/ui/views/layout/webapps/webview)
