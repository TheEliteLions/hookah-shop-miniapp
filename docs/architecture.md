# Архитектура

Vite раздаёт React SPA через Cloudflare Pages. Браузер использует Supabase JS SDK с публичным publishable/anon ключом. PostgreSQL хранит `products` и `admin_users`; Auth хранит учётные записи и подтверждения e-mail; Storage хранит изображения товаров. В браузере нет server/service role key.

`products` доступна на чтение anon/authenticated, но RLS возвращает публично только `is_published=true`. Все мутации проверяют `public.is_admin()` на стороне БД. `admin_users` доступна authenticated только для чтения собственной роли через отдельную RLS-политику; права на запись закрыты. `is_admin()` работает как `SECURITY INVOKER`, поэтому не обходит RLS. Владелец добавляет первый UUID только через доверенный SQL Editor.

Корзина хранится только в `localStorage` браузера. Checkout показывает объяснение режима демо и очищает локальную корзину только по явному нажатию; серверная запись заказа отсутствует.

Android APK — тонкая WebView оболочка опубликованного HTTPS сайта. WebView допускает только configured production host, без JavaScript bridge; внешние ссылки передаются Android браузеру. APK нужен интернет и работающий hosting/backend.
