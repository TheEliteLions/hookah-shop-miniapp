# Первоначальное назначение администратора

1. Разверните Supabase migrations и настройте Auth.
2. Создайте владельческий аккаунт штатно через Supabase Auth и подтвердите e-mail.
3. В Dashboard → Authentication → Users скопируйте UUID нужной учётной записи и внимательно проверьте его.
4. Выполните через доверенный SQL Editor (не через публичный frontend API):

```sql
insert into public.admin_users (user_id)
select id from auth.users where id = '<AUTH_USER_UUID>'::uuid
on conflict (user_id) do nothing;
```

Запрос добавит ровно существующий аккаунт, указанный UUID. Не размещайте настоящий e-mail, UUID, service key или SQL credentials в публичном Git. Удаление роли: `delete from public.admin_users where user_id = '<AUTH_USER_UUID>'::uuid;` — также только владельцем в SQL Editor.
