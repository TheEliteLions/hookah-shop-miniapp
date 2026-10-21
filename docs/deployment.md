# Настройка Supabase и Cloudflare Pages

## Supabase

1. Создайте проект, сохраните database password в менеджере секретов и не передавайте её frontend.
2. Установите CLI и залогиньтесь; привяжите этот каталог к project ref.
3. Примените `supabase/migrations/202610210001_catalog_security.sql` через `supabase db push`.
4. Локально `supabase db start` применяет миграцию и `supabase/seed.sql`; seed не обновляет уже существующие товары. Для production запускайте seed только один раз через SQL Editor.
5. В Dashboard Auth → Sign In / Providers отключите `Allow new users to sign up` в production до privacy review. UI toggle сам по себе не защищает публичный Auth endpoint; серверная настройка Supabase является обязательной. Для локальной разработки можно временно включить регистрацию. В Auth настройте Site URL на фактический HTTPS Pages URL и allowlist для него и локального `http://localhost:5173`. Оставьте email confirmation включённым и настройте почтовую доставку. Redirect для recovery также должен попадать на `VITE_SITE_URL`.
6. Положите URL проекта и publishable key в `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`; никогда не добавляйте `service_role`.
7. Назначьте владельца админом по `docs/admin-bootstrap.md`. Проверьте доступы через тесты и реальный второй обычный аккаунт.
8. Локально запускайте SQL тесты командами `supabase db start` и `supabase test db`; GitHub workflow повторяет эти шаги на push/PR.

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
