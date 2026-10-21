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
9. Локально запускайте SQL тесты командами `supabase db start` и `supabase test db`. GitHub workflow повторяет эти шаги на push/PR. Исправленные 23 pgTAP assertions прошли в workflow для `f5ff9ea`; локально Docker отсутствует.

### Read-only preflight 2026-10-21

CLI project list подтвердил проект `Project_hookah-shop`, ref `aehleysdsmgqjseghgmn`, статус `ACTIVE_HEALTHY`, регион `eu-west-3`; ref совпадает с URL в игнорируемом `.env.local`. До изменения проверены пустая история миграций, пустая схема `public`, отсутствие Storage policies/bucket; `db push --dry-run` показал только `202610210001_catalog_security.sql`. После проверки pgTAP миграция применена, seed запущен отдельно. Read-only проверка подтвердила 2 таблицы (`products`, `admin_users`), 6 policies `public`, 4 Storage policies, публичный bucket изображений с лимитом 5 MiB и 10 опубликованных demo rows. Auth Site URL установлен в `https://nocturne-hookah-mvp.pages.dev`, allowlist содержит production origin и `http://localhost:5173`; email-провайдер включён, глобальная регистрация выключена до privacy review.

## Cloudflare Pages

Выберите Vite framework preset или manual: install command `npm ci`, build command `npm run build`, output directory `dist`. Настройте production variables с теми же безопасными public values; установите `VITE_SITE_URL` в реальный URL. Публичный signup оставьте false до privacy review. Добавьте домен Pages в Supabase Auth redirect allowlist. При Git integration Cloudflare сам запускает деплой на push в `main`. GitHub Actions workflow `.github/workflows/cloudflare-pages.yml` оставлен для ручного деплоя (`workflow_dispatch`), чтобы не создавать два параллельных production deployment на каждый push. Для ручного workflow задайте GitHub repository variables `CLOUDFLARE_PAGES_PROJECT`, `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`, `VITE_SITE_URL`, `VITE_PUBLIC_SIGNUP_ENABLED` и secrets `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`.

Production deployment выполнен прямой загрузкой Wrangler CLI в `nocturne-hookah-mvp`; URL: `https://nocturne-hookah-mvp.pages.dev`. GitHub repository integration пока не настроена. Для будущего GitHub Actions deployment добавьте repository variables `CLOUDFLARE_PAGES_PROJECT=nocturne-hookah-mvp`, `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`, `VITE_SITE_URL=https://nocturne-hookah-mvp.pages.dev`, `VITE_PUBLIC_SIGNUP_ENABLED=false` и secrets `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`. Не используйте `service_role`/`sb_secret`.

## Android

Workflow `android-apk.yml` запускается на push в `main` или вручную; URL по умолчанию — `https://nocturne-hookah-mvp.pages.dev`, при необходимости можно переопределить Actions variable `WEB_APP_URL`. Он публикует debug APK как GitHub Actions artifact. Это тестовая debug сборка, не подписанный Google Play release. Для Play Store владелец отдельно организует signing key и безопасные secrets.

## Тарифы и официальные инструкции

Перед реальным запуском повторно проверьте текущие лимиты и бесплатный тариф на официальных страницах Supabase, Cloudflare Pages и Android WebView. Бесплатный план не является гарантией uptime/SLA; демо без настроенной почты не подтверждает работоспособность confirmation flow.

- [Supabase Auth configuration](https://supabase.com/docs/guides/auth/general-configuration)
- [Supabase RLS, grants and policies](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Supabase Storage access control](https://supabase.com/docs/guides/storage/security/access-control)
- [Cloudflare Pages limits](https://developers.cloudflare.com/pages/platform/limits/)
- [Android WebView guide](https://developer.android.com/develop/ui/views/layout/webapps/webview)
