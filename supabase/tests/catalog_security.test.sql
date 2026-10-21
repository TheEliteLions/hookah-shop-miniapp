begin;
select plan(24);
insert into auth.users (id,aud,role,email,encrypted_password,email_confirmed_at,created_at,updated_at)
values ('10000000-0000-4000-8000-000000000001','authenticated','authenticated','mvp-test-user@example.invalid','x',now(),now(),now()),
       ('10000000-0000-4000-8000-000000000002','authenticated','authenticated','mvp-test-admin@example.invalid','x',now(),now(),now())
on conflict (id) do nothing;
insert into public.admin_users(user_id) values ('10000000-0000-4000-8000-000000000002') on conflict do nothing;
insert into public.products(slug,name,category,price,is_published) values
('test-published','Published test item','Кальяны',1,true),('test-draft','Draft test item','Кальяны',1,false)
on conflict(slug) do nothing;

set local role anon;
select is((select count(*)::int from public.products where slug like 'test-%'),1,'anon sees published item only');
select throws_ok($$insert into public.products(slug,name,category,price) values('anon-write','x','Кальяны',1)$$, '42501', null, 'anon cannot insert product');
select throws_ok($$insert into storage.objects(bucket_id,name) values('product-images','test/anon.webp')$$, '42501', null, 'anon cannot upload product image');
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub','10000000-0000-4000-8000-000000000001',true);
select is((select public.is_admin()),false,'ordinary account is not admin');
select is((select count(*)::int from public.admin_users),0,'ordinary account cannot read other admin roles');
select throws_ok($$insert into public.products(slug,name,category,price) values('user-write','x','Кальяны',1)$$, '42501', null, 'ordinary account cannot insert product');
select throws_ok($$insert into public.admin_users(user_id) values ('10000000-0000-4000-8000-000000000001')$$, '42501', null, 'ordinary account cannot grant itself admin');
select lives_ok($$update public.products set is_published=false where slug='test-published'$$,'ordinary update attempt completes without changing a visible row');
select is((select is_published from public.products where slug='test-published'),true,'ordinary account cannot update product');
select lives_ok($$delete from public.products where slug='test-published'$$,'ordinary delete attempt completes without changing a visible row');
select is((select count(*)::int from public.products where slug='test-published'),1,'ordinary account cannot delete product');
select throws_ok($$insert into storage.objects(bucket_id,name) values('product-images','test/user.webp')$$, '42501', null, 'ordinary account cannot upload product image');
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub','10000000-0000-4000-8000-000000000002',true);
select is((select public.is_admin()),true,'admin role is resolved from protected table');
select is((select count(*)::int from public.admin_users),1,'admin can read own admin role');
select lives_ok($$insert into public.products(slug,name,category,price) values('admin-write','Admin item','Кальяны',1)$$,'admin can insert product');
select lives_ok($$update public.products set description='Updated by admin' where slug='admin-write'$$,'admin can update product');
select lives_ok($$delete from public.products where slug='admin-write'$$,'admin can delete product');
select is((select count(*)::int from public.products where slug='test-draft'),1,'admin can read draft product');
select lives_ok($$insert into storage.objects(bucket_id,name) values('product-images','test/admin.webp')$$,'admin can upload product image');
select is((select count(*)::int from pg_policies where schemaname='storage' and tablename='objects' and policyname='public reads product images' and cmd='SELECT' and roles @> ARRAY['anon','authenticated']::name[]),1,'public image read policy exists');
select is((select count(*)::int from pg_policies where schemaname='storage' and tablename='objects' and policyname='admins upload product images' and cmd='INSERT' and roles @> ARRAY['authenticated']::name[] and position('is_admin' in coalesce(with_check,'')) > 0),1,'admin-only upload policy exists');
select is((select count(*)::int from pg_policies where schemaname='storage' and tablename='objects' and policyname='admins update product images' and cmd='UPDATE' and roles @> ARRAY['authenticated']::name[] and position('is_admin' in coalesce(qual,'')) > 0 and position('is_admin' in coalesce(with_check,'')) > 0),1,'admin-only update policy exists');
select is((select count(*)::int from pg_policies where schemaname='storage' and tablename='objects' and policyname='admins delete product images' and cmd='DELETE' and roles @> ARRAY['authenticated']::name[] and position('is_admin' in coalesce(qual,'')) > 0),1,'admin-only delete policy exists');
select * from finish();
rollback;
