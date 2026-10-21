# NOCTURNE — сводка проекта

## Кратко о проекте

NOCTURNE — разработанный MVP русскоязычного интернет-каталога кальянных аксессуаров. Проект объединяет адаптивное веб-приложение, облачное хранение данных и изображений, пользовательскую авторизацию, административное управление каталогом и Android-приложение.

**Демо:** [nocturne-hookah-mvp.pages.dev](https://nocturne-hookah-mvp.pages.dev)  
**Исходный код:** [GitHub — hookah-shop-miniapp](https://github.com/TheEliteLions/hookah-shop-miniapp)

## Что реализовано

- Каталог товаров с поиском, фильтрацией по категориям и сортировкой.
- Просмотр карточки товара с фотографией и описанием.
- Корзина с изменением количества и расчётом итоговой суммы.
- Регистрация, вход и выход пользователя с помощью Supabase Auth.
- Административная панель для добавления, редактирования, публикации и скрытия товаров.
- Загрузка фотографий товаров в Supabase Storage.
- Android-приложение на Kotlin с WebView и фирменной иконкой.
- Адаптивное оформление для настольных и мобильных экранов.

## Технологический стек

- **Frontend:** React 19, TypeScript, Vite.
- **База данных и авторизация:** Supabase PostgreSQL и Supabase Auth.
- **Контроль доступа:** PostgreSQL Row Level Security (RLS) и отдельная модель административных ролей.
- **Файлы:** Supabase Storage с политиками доступа.
- **Android:** Kotlin и Android WebView.
- **Автоматизация:** GitHub Actions для CI, SQL-тестов и сборки APK.
- **Веб-публикация:** Cloudflare Pages.

## Безопасность и качество

Права на чтение и изменение каталога контролируются RLS-политиками в базе данных. Обычная регистрация не назначает административную роль. Набор pgTAP проверяет права доступа на уровне базы; зафиксированный запуск database workflow проверил 23 утверждения. Публичная клиентская часть использует только publishable-параметры Supabase.

Для проекта настроены lint, TypeScript typecheck и production build. Для Android настроена автоматическая сборка debug APK, доступного среди артефактов GitHub Actions.

## Результат

Получен опубликованный веб-MVP с подключённым каталогом и пользовательскими сценариями, инструментами администратора для управления товарами и Android-сборкой для тестирования. Оформление заказа представлено как демонстрационный сценарий корзины и checkout.

**Ссылки:**

- [Работающий сайт](https://nocturne-hookah-mvp.pages.dev)
- [GitHub-репозиторий](https://github.com/TheEliteLions/hookah-shop-miniapp)
- [CI workflow](https://github.com/TheEliteLions/hookah-shop-miniapp/actions/workflows/ci.yml)
- [SQL-тесты RLS](https://github.com/TheEliteLions/hookah-shop-miniapp/actions/workflows/database-tests.yml)
- [Сборка Android APK](https://github.com/TheEliteLions/hookah-shop-miniapp/actions/workflows/android-apk.yml)
