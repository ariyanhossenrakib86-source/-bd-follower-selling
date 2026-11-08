-- BD Follower Selling: Supabase SQL Editor-এ পুরোটা Run করুন।
-- Admin email: shekroni798@gmail.com
create table if not exists public.services (
  id bigint generated always as identity primary key,
  platform text not null check (platform in ('facebook','youtube','instagram')),
  title text not null,
  hint text not null default '',
  link_label text not null default 'লিংক',
  placeholder text not null default 'https://',
  rate numeric not null check (rate > 0),
  qty integer[] not null default '{100,500,1000,5000}',
  sort integer not null default 0,
  active boolean not null default true,
  unique(platform,title)
);
create table if not exists public.settings (key text primary key,value text not null default '');
create or replace function public.is_admin() returns boolean
language sql stable as $$
 select lower(coalesce(auth.jwt()->>'email','')) = 'shekroni798@gmail.com'
$$;
alter table public.services enable row level security;
alter table public.settings enable row level security;
drop policy if exists "services public read" on public.services;
drop policy if exists "services admin manage" on public.services;
drop policy if exists "settings public read" on public.settings;
drop policy if exists "settings admin manage" on public.settings;
create policy "services public read" on public.services for select using (active = true or public.is_admin());
create policy "services admin manage" on public.services for all using (public.is_admin()) with check (public.is_admin());
create policy "settings public read" on public.settings for select using (true);
create policy "settings admin manage" on public.settings for all using (public.is_admin()) with check (public.is_admin());
insert into public.settings(key,value) values ('brand','BD Follower Selling'),('whatsapp','8801891827498')
on conflict(key) do update set value=excluded.value;
insert into public.services(platform,title,hint,rate,qty,sort) values
('facebook','ফলোয়ার','Facebook',0.60,'{100,500,1000,5000}',1),
('facebook','লাইক','Facebook',0.35,'{100,500,1000,5000}',2),
('facebook','কমেন্ট','Facebook',3,'{10,25,50,100}',3),
('facebook','ভিউ','Facebook',0.05,'{1000,5000,10000,50000}',4),
('youtube','সাবস্ক্রাইবার','YouTube',2.50,'{50,100,500,1000}',1),
('youtube','লাইক','YouTube',0.50,'{100,500,1000,5000}',2),
('youtube','কমেন্ট','YouTube',4,'{10,25,50,100}',3),
('youtube','ভিউ','YouTube',0.12,'{1000,5000,10000,50000}',4),
('instagram','ফলোয়ার','Instagram',0.70,'{100,500,1000,5000}',1),
('instagram','লাইক','Instagram',0.30,'{100,500,1000,5000}',2),
('instagram','কমেন্ট','Instagram',3,'{10,25,50,100}',3),
('instagram','ভিউ','Instagram',0.04,'{1000,5000,10000,50000}',4)
on conflict(platform,title) do nothing;
