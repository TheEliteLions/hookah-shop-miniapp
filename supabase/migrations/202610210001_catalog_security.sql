-- Catalog schema, role boundary and image access for the demo store.
create extension if not exists pgcrypto with schema extensions;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  name text not null check (length(trim(name)) between 1 and 120),
  description text not null default '' check (length(description) <= 4000),
  category text not null check (category in ('Кальяны','Чаши','Колбы','Шланги и мундштуки','Аксессуары')),
  price numeric(10,2) not null check (price >= 0),
  currency char(3) not null default 'PLN' check (currency = 'PLN'),
  attributes jsonb not null default '{}'::jsonb check (jsonb_typeof(attributes) = 'object'),
  image_paths text[] not null default '{}',
  is_published boolean not null default false,
  sort_order integer not null default 0,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.products enable row level security;
alter table public.admin_users enable row level security;

create or replace function public.set_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin new.updated_at = now(); return new; end;
$$;
drop trigger if exists products_set_updated_at on public.products;
create trigger products_set_updated_at before update on public.products
for each row execute function public.set_updated_at();

create or replace function public.is_admin()
returns boolean language sql stable security invoker set search_path = '' as $$
  select exists (select 1 from public.admin_users au where au.user_id = (select auth.uid()));
$$;
revoke all on function public.is_admin() from public, anon, authenticated;
grant execute on function public.is_admin() to authenticated;
revoke all on function public.set_updated_at() from public, anon, authenticated;

revoke all on public.products from public, anon, authenticated;
grant select on public.products to anon, authenticated;
grant insert, update, delete on public.products to authenticated;
revoke all on public.admin_users from public, anon, authenticated;
grant select on public.admin_users to authenticated;
drop policy if exists "users read own admin role" on public.admin_users;
create policy "users read own admin role" on public.admin_users
for select to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "published products are readable" on public.products;
drop policy if exists "public reads published products" on public.products;
create policy "public reads published products" on public.products
for select to anon using (is_published);
drop policy if exists "users read published and admins read all products" on public.products;
create policy "users read published and admins read all products" on public.products
for select to authenticated using (is_published or public.is_admin());
drop policy if exists "admins insert products" on public.products;
create policy "admins insert products" on public.products
for insert to authenticated with check (public.is_admin() and (created_by is null or created_by = auth.uid()));
drop policy if exists "admins update products" on public.products;
create policy "admins update products" on public.products
for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admins delete products" on public.products;
create policy "admins delete products" on public.products
for delete to authenticated using (public.is_admin());

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-images','product-images',true,5242880,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public=true,file_size_limit=5242880,allowed_mime_types=array['image/jpeg','image/png','image/webp'];
drop policy if exists "public reads product images" on storage.objects;
create policy "public reads product images" on storage.objects for select to anon, authenticated
using (bucket_id = 'product-images');
drop policy if exists "admins upload product images" on storage.objects;
create policy "admins upload product images" on storage.objects for insert to authenticated
with check (bucket_id = 'product-images' and public.is_admin());
drop policy if exists "admins update product images" on storage.objects;
create policy "admins update product images" on storage.objects for update to authenticated
using (bucket_id = 'product-images' and public.is_admin()) with check (bucket_id = 'product-images' and public.is_admin());
drop policy if exists "admins delete product images" on storage.objects;
create policy "admins delete product images" on storage.objects for delete to authenticated
using (bucket_id = 'product-images' and public.is_admin());
