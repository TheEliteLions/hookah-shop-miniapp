# NOCTURNE — демонстрационный каталог

Русскоязычный адаптивный каталог предметов для кальянного ритуала с подключаемыми Supabase Auth, PostgreSQL, RLS и Storage. Корзина работает локально в браузере, а экран checkout только объясняет демонстрационный режим: заказ, платёж, адрес и телефон не создаются и не собираются. Товары и цены — демонстрационные; продажа регулируемых расходников не предусмотрена.

## Стек и запуск

- React + TypeScript + Vite.
- Supabase Auth и PostgreSQL, миграции в `supabase/migrations/`.
- Supabase Storage bucket `product-images` с публичным чтением и admin-only записью.
- Исходный код опубликован в GitHub; основной GitHub Actions CI проходит. Cloudflare Pages и облачная база пока не настроены.
- Android Kotlin WebView wrapper и workflow для debug APK.

Требуется Node.js 20.19+ или 22.12+ и npm. Скопируйте `.env.example` в `.env.local` и укажите Supabase project URL и publishable key. Пока параметры пусты, приложение открывает UI-заглушку вместо выдуманного локального каталога.

```sh
npm ci
npm run dev
npm run typecheck
npm run lint
npm run build
```

Подготовка базы: установите/запустите Supabase CLI, выполните `supabase login`, проверьте выбранный проект и его историю миграций, затем сверьте план командой `supabase db push --dry-run --project-ref <project-ref>`. Не применяйте миграции, пока владелец не проверил dry-run. После отдельного подтверждения миграции применяются через `supabase db push`; демонстрационный seed можно запустить через SQL Editor. Подробности и read-only проверки приведены в `docs/deployment.md`.

## Настройка администратора

Создайте/подтвердите обычный Auth аккаунт и получите его UUID в Supabase Dashboard → Authentication → Users. После проверки идентификатора выполните шаблон в `docs/admin-bootstrap.md` через доверенный SQL Editor. Обычная регистрация не присваивает роль. `VITE_PUBLIC_SIGNUP_ENABLED=false` отключает ссылку регистрации в UI; production sign-up оставляйте выключенным до privacy review.

## Безопасность и объём

Клиенту разрешены только project URL и publishable/anon key. Никогда не добавляйте `service_role`, database password или signing key в `.env`, frontend bundle, Android APK либо Git. PostgreSQL RLS защищает draft visibility и writes; один лишь маршрут админки не является защитой. Изображения ограничены JPG/PNG/WebP и 5 MiB.

Реальные заказы, платежи, доставка, адреса, телефоны, табак, никотин, вейпы и иные регулируемые расходники не входят в MVP. До реальных продаж проверьте рынок, требования Польши/ЕС, privacy, возрастные ограничения и правила торговли с профильными специалистами. См. `docs/legal-review.md`.

## Текущий статус

Исходный код опубликован в [GitHub](https://github.com/TheEliteLions/hookah-shop-miniapp); основной CI на `main` проходит. Облачная база Supabase ещё не настроена: проект ref проверен, удалённая история миграций и схема `public` пусты, Storage bucket отсутствует. `supabase db push --dry-run --linked` показывает только миграцию `202610210001_catalog_security.sql`; она не применялась. Database workflow выявил некорректные pgTAP assertions: вложенный data-modifying CTE, отсутствующую `has_policy()`, попытку прямого удаления объекта Storage через SQL и неверный план тестов (объявлено 24, фактически 23). Исправления включены; успешный workflow ещё не подтверждён. Локально Docker отсутствует. Cloudflare Pages и Android APK ещё не опубликованы. См. `ROADMAP.md` для статуса.
