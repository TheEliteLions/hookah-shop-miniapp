# Roadmap и критерии приёмки

## Выполнено локально

- [x] React/TypeScript/Vite приложение с русским адаптивным premium-minimal интерфейсом.
- [x] Каталог, поиск, категория и сортировка с загрузкой опубликованных записей из Supabase.
- [x] Корзина с количеством и суммой; демонстрационный checkout без заказа, оплаты или сбора контактов.
- [x] Supabase email/password signup/login/logout/reset flow и feature flag регистрации.
- [x] Админ CRUD, публикация/скрытие и управление файлами в Storage; проверка роли через БД.
- [x] SQL schema, RLS, явные grants, ограничения, приватная таблица ролей, Storage policies и неразрушающий seed.
- [x] Основные инструкции по настройке и review privacy/legal.
- [x] GitHub CI/Cloudflare deploy и Android APK workflow подготовлены локально.

## Требует выполнения/проверки

- [x] Установить зависимости; typecheck, lint и production build завершились успешно.
- [x] Выполнить SQL access tests в изолированном Supabase/Docker окружении GitHub Actions; локально Docker отсутствует.
- [x] Добавить pgTAP доступ-тесты и GitHub Actions database workflow.
- [x] Подтвердить pgTAP исправление повторным GitHub workflow: 23 assertions прошли для коммита `f5ff9ea`.
- [x] Применить проверенную миграцию и безопасный seed к пустому Supabase-проекту; проверка подтвердила 10 опубликованных демонстрационных товаров.
- [x] Начальный read-only preflight подтвердил целевой ref `aehleysdsmgqjseghgmn` / `Project_hookah-shop` и пустую базу до миграции.
- [x] Выполнить `supabase db push --dry-run --linked`: показана только `202610210001_catalog_security.sql`; никаких удалённых изменений не выполнялось.
- [x] Настроить Supabase Auth Site URL и redirect allowlist; включить signup по запросу владельца после публикации privacy notice. Email confirmation оставлено выключенным до настройки SMTP.
- [x] Владелец подтвердил свой Auth account, админ-доступ и добавление опубликованного товара с фотографией; публичная регистрация не назначает роль.
- [x] Опубликовать исходный код в целевом GitHub repository; основной CI на `main` прошёл для коммита `7473bdf`.
- [x] Опубликовать Cloudflare Pages production site и проверить Supabase catalog loading: https://nocturne-hookah-mvp.pages.dev.
- [ ] Настроить Cloudflare Git integration или GitHub Actions secrets для дальнейшего автодеплоя; текущий deployment загружен прямым Wrangler CLI.
- [x] Собрать Android debug APK artifact в GitHub Actions для коммита `4de3197`; workflow завершился успешно.
- [x] Проверить desktop и mobile layout в локальном браузере; горизонтального overflow нет.
- [ ] Проверить Android WebView на устройстве/эмуляторе.
- [x] Собрать Android APK artifact в GitHub Actions; установка и проверка на физическом устройстве ещё не выполнены.

## Проверочный журнал

- `npm ci` — passed (184 packages audited; 0 vulnerabilities).
- `npm run typecheck` — passed.
- `npm run lint` — passed.
- `npm run build` — passed (Vite production bundle).
- Browser preview — checked desktop and 390 px mobile width; no horizontal overflow; no browser console errors.
- SQL pgTAP — GitHub database workflow passed all 23 assertions for `f5ff9ea`. Previous failures exposed the nested data-modifying CTE, nonexistent `has_policy()`, Storage's guard against direct SQL DELETE, and the 24-versus-23 test-plan mismatch; each was corrected. Local Docker is unavailable.
- Android APK — not built locally: Gradle command/wrapper is unavailable and local Android Studio runtime is JDK 25; the configured CI pins a compatible Java 17/Gradle 8.13 toolchain.
- GitHub CI, Supabase database tests, and Android APK workflow passed for commits `4de3197` and `c324430`. Supabase CLI 2.121.0 is authenticated. Migration `202610210001` and seed are applied; owner has added an 11th test item with one image to the confirmed project; Auth Site URL/redirects are configured and global signup is enabled; email confirmation is currently disabled pending custom SMTP.
- Cloudflare Pages is live at `https://nocturne-hookah-mvp.pages.dev`; deployment was a direct Wrangler upload, not Git-integrated. No custom SMTP is configured; default email delivery limits may prevent reliable confirmations/resets.
- Android debug APK artifact was uploaded successfully by workflow run `39591634637`; install and device-level WebView verification remain pending.

## Критерии приёмки

- Каталог работает с PostgreSQL; anon видит только опубликованные товары.
- Только админ может выполнять CRUD товара и Storage write; обычный пользователь не может выдать себе роль.
- Auth login/admin role and owner-added product/photo verified. Signup is enabled with email auto-confirm; reset emails for non-team addresses require custom SMTP. Privacy notice is published; the owner still needs to verify its legal basis, retention periods and vendor terms.
- Demo cart/checkout не сохраняют заказ и не запрашивают платёжные/доставочные данные.
- Lint, typecheck, production build и SQL tests имеют записанные фактические результаты.
- Публичный HTTPS сайт и APK artifact доступны и проверены либо конкретный внешний блокер указан.
