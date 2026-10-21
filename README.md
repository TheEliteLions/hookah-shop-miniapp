# NOCTURNE — демонстрационный каталог

Русскоязычный адаптивный каталог предметов для кальянного ритуала с подключаемыми Supabase Auth, PostgreSQL, RLS и Storage. Корзина работает локально в браузере, а экран checkout только объясняет демонстрационный режим: заказ, платёж, адрес и телефон не создаются и не собираются. Товары и цены — демонстрационные; продажа регулируемых расходников не предусмотрена.

## Стек и запуск

- React + TypeScript + Vite.
- Supabase Auth и PostgreSQL, миграции в `supabase/migrations/`.
- Supabase Storage bucket `product-images` с публичным чтением и admin-only записью.
- Исходный код опубликован в GitHub; основной GitHub Actions CI и Supabase tests проходят. Сайт развёрнут на Cloudflare Pages и подключён к Supabase.
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

Создайте/подтвердите обычный Auth аккаунт и получите его UUID в Supabase Dashboard → Authentication → Users. После проверки идентификатора выполните шаблон в `docs/admin-bootstrap.md` через доверенный SQL Editor. Обычная регистрация не присваивает роль. `VITE_PUBLIC_SIGNUP_ENABLED=true` показывает ссылку регистрации; production sign-up также управляется настройкой Supabase Auth. Актуальные статус регистрации и ограничения почты описаны ниже.

## Безопасность и объём

Клиенту разрешены только project URL и publishable/anon key. Никогда не добавляйте `service_role`, database password или signing key в `.env`, frontend bundle, Android APK либо Git. PostgreSQL RLS защищает draft visibility и writes; один лишь маршрут админки не является защитой. Изображения ограничены JPG/PNG/WebP и 5 MiB.

Реальные заказы, платежи, доставка, адреса, телефоны, табак, никотин, вейпы и иные регулируемые расходники не входят в MVP. До реальных продаж проверьте рынок, требования Польши/ЕС, privacy, возрастные ограничения и правила торговли с профильными специалистами. См. `docs/legal-review.md`.

## Текущий статус

Исходный код опубликован в [GitHub](https://github.com/TheEliteLions/hookah-shop-miniapp); CI, Supabase database tests и Android APK workflow прошли для коммита `c324430`. APK с иконкой кальяна доступен в разделе Artifacts успешного [Android workflow](https://github.com/TheEliteLions/hookah-shop-miniapp/actions/runs/39597086033); установка на устройство ещё не проверена. Сайт опубликован на [Cloudflare Pages](https://nocturne-hookah-mvp.pages.dev). В Supabase применена миграция `202610210001_catalog_security.sql`, 10 demo-записей и тестовая карточка владельца; всего 11 опубликованных товаров, один с фото. RLS/Storage policies прошли pgTAP (23 assertions). Владелец подтвердил аккаунт администратора и проверил добавление товара с фото. Публичная регистрация включена; подтверждение e-mail отключено (auto-confirm), поскольку custom SMTP не настроен. Для надёжного восстановления пароля и подтверждающих писем настройте SMTP. Уведомление `/privacy.html` опубликовано; его правовое основание, сроки хранения и условия поставщиков владелец должен проверить с профильным специалистом. Checkout остаётся демонстрационным. Production Pages развёрнут прямой загрузкой Wrangler; Git-интеграция/автодеплой и SMTP не настроены. См. `ROADMAP.md` и `docs/deployment.md`.
