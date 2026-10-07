-- SOLO PARA EL PROYECTO SUPABASE DE PRUEBAS (nunca el de producción).
-- Ejecutar en: Supabase (proyecto de pruebas) > SQL Editor > New query > Run.

-- 1) Tabla base (la que ya existía en producción)
create table if not exists public.clientes (
  id uuid primary key default gen_random_uuid(),
  name text,
  phone text,
  date date,
  created_at timestamptz default now()
);

-- 2) Seguridad: solo usuarios con sesión iniciada
alter table public.clientes enable row level security;
drop policy if exists "usuarios autenticados" on public.clientes;
create policy "usuarios autenticados" on public.clientes
  for all to authenticated using (true) with check (true);

-- 3) Columnas del talonario (mismas que tu supabase_update.sql, con startt_date como usa el código)
alter table public.clientes
  add column if not exists startt_date date,
  add column if not exists receipt_number text,
  add column if not exists booklet_number text,
  add column if not exists age integer,
  add column if not exists delivery_date date,
  add column if not exists delivery_time time,
  add column if not exists frame text,
  add column if not exists model text,
  add column if not exists brand text,
  add column if not exists lenses text,
  add column if not exists doctor_prescription text,
  add column if not exists detail text,
  add column if not exists delivered_by text,
  add column if not exists account numeric(10,2) default 0,
  add column if not exists balance numeric(10,2) default 0,
  add column if not exists total numeric(10,2) default 0,
  add column if not exists far_od_sph text,
  add column if not exists far_od_cyl text,
  add column if not exists far_od_axis text,
  add column if not exists far_oi_sph text,
  add column if not exists far_oi_cyl text,
  add column if not exists far_oi_axis text,
  add column if not exists addition text,
  add column if not exists dp text,
  add column if not exists near_od_sph text,
  add column if not exists near_od_cyl text,
  add column if not exists near_od_axis text,
  add column if not exists near_oi_sph text,
  add column if not exists near_oi_cyl text,
  add column if not exists near_oi_axis text;

create index if not exists idx_clientes_receipt_number on public.clientes (receipt_number);
create index if not exists idx_clientes_phone on public.clientes (phone);
