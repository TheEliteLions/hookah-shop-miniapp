# NOCTURNE — демонстрационный каталог

Русскоязычный адаптивный каталог предметов для кальянного ритуала с подключаемыми Supabase Auth, PostgreSQL, RLS и Storage. Корзина работает локально в браузере, а экран checkout только объясняет демонстрационный режим: заказ, платёж, адрес и телефон не создаются и не собираются. Товары и цены — демонстрационные; продажа регулируемых расходников не предусмотрена.

## Стек и запуск

- React + TypeScript + Vite.
- Supabase Auth и PostgreSQL, миграции в `supabase/migrations/`.
- Supabase Storage bucket `product-images` с публичным чтением и admin-only записью.
- Cloudflare Pages и GitHub Actions подготовлены, но ещё не подключены к аккаунтам.
- Android Kotlin WebView wrapper и workflow для debug APK.

Требуется Node.js 20.19+ или 22.12+ и npm. Скопируйте `.env.example` в `.env.local` и укажите Supabase project URL и publishable key. Пока параметры пусты, приложение открывает UI-заглушку вместо выдуманного локального каталога.

```sh
npm ci
npm run dev
npm run typecheck
npm run lint
npm run build
```

Развёртывание базы: установите Supabase CLI, выполните `supabase login`, `supabase link --project-ref <project-ref>`, затем `supabase db push`. Для первоначальных демо-товаров выполните `supabase/seed.sql` через SQL Editor или `supabase db execute --file supabase/seed.sql`. Настройки проекта и проверка Auth описаны в `docs/deployment.md`.

## Настройка администратора

Создайте/подтвердите обычный Auth аккаунт и получите его UUID в Supabase Dashboard → Authentication → Users. После проверки идентификатора выполните шаблон в `docs/admin-bootstrap.md` через доверенный SQL Editor. Обычная регистрация не присваивает роль. `VITE_PUBLIC_SIGNUP_ENABLED=false` отключает ссылку регистрации в UI; production sign-up оставляйте выключенным до privacy review.

## Безопасность и объём

Клиенту разрешены только project URL и publishable/anon key. Никогда не добавляйте `service_role`, database password или signing key в `.env`, frontend bundle, Android APK либо Git. PostgreSQL RLS защищает draft visibility и writes; один лишь маршрут админки не является защитой. Изображения ограничены JPG/PNG/WebP и 5 MiB.

Реальные заказы, платежи, доставка, адреса, телефоны, табак, никотин, вейпы и иные регулируемые расходники не входят в MVP. До реальных продаж проверьте рынок, требования Польши/ЕС, privacy, возрастные ограничения и правила торговли с профильными специалистами. См. `docs/legal-review.md`.

## Текущий статус

npm ci, lint, typecheck и production build проходят. pgTAP не запускался: в локальной среде нет Docker. Supabase CLI 2.121.0 доступен через npx, но dry-run ждёт авторизации; удалённая схема не изменялась. Git remote задан для пустого репозитория, но коммиты и push ждут Git author identity и GitHub write authentication. Cloudflare Pages и Android APK ещё не опубликованы. См. `ROADMAP.md` для статуса.
