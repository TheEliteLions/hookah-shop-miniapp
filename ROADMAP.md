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
- [ ] Выполнить SQL tests в локальном Supabase/Docker. Supabase CLI 2.121.0 доступен через `npx`, но Docker отсутствует; GitHub database workflow завершился ошибкой.
- [x] Добавить pgTAP доступ-тесты и GitHub Actions database workflow.
- [ ] Исправить первый запуск GitHub database workflow: шаг `supabase test db` завершился ошибкой для коммита `7473bdf`; для изучения подробных логов требуются права администратора репозитория. SQL assertions не подтверждены.
- [ ] Применить миграции/seed к реальному или локальному Supabase и выполнить SQL access tests.
- [ ] Проверить реальные Auth redirect/confirmation настройки и назначить владельцем первого admin UUID.
- [x] Опубликовать исходный код в целевом GitHub repository; основной CI на `main` прошёл для коммита `7473bdf`.
- [ ] Создать Cloudflare Pages deployment, проверить HTTPS URL и production env.
- [ ] Передать production URL в `WEB_APP_URL`, собрать и скачать APK artifact.
- [x] Проверить desktop и mobile layout в локальном браузере; горизонтального overflow нет.
- [ ] Проверить Android WebView на устройстве/эмуляторе.
- [ ] Собрать Android APK artifact в GitHub Actions.

## Проверочный журнал

- `npm ci` — passed (184 packages audited; 0 vulnerabilities).
- `npm run typecheck` — passed.
- `npm run lint` — passed.
- `npm run build` — passed (Vite production bundle).
- Browser preview — checked desktop and 390 px mobile width; no horizontal overflow; no browser console errors.
- SQL pgTAP — GitHub database workflow failed at `supabase test db` for commit `7473bdf`; detailed logs require repository admin access. Not run locally because Docker is unavailable. No pass is claimed.
- Android APK — not built locally: Gradle command/wrapper is unavailable and local Android Studio runtime is JDK 25; the configured CI pins a compatible Java 17/Gradle 8.13 toolchain.
- GitHub CI — passed for `7473bdf`; Supabase database tests — failed for that commit. Supabase CLI 2.121.0 is available through `npx` but not authenticated; no remote schema was queried or changed.
- Supabase database and Cloudflare production deployment — not configured or deployed.

## Критерии приёмки

- Каталог работает с PostgreSQL; anon видит только опубликованные товары.
- Только админ может выполнять CRUD товара и Storage write; обычный пользователь не может выдать себе роль.
- Auth reset и email confirmation проверены на фактической конфигурации Supabase.
- Demo cart/checkout не сохраняют заказ и не запрашивают платёжные/доставочные данные.
- Lint, typecheck, production build и SQL tests имеют записанные фактические результаты.
- Публичный HTTPS сайт и APK artifact доступны и проверены либо конкретный внешний блокер указан.
