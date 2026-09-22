-- Ejecutar UNA VEZ en Supabase > SQL Editor.
-- No elimina ni modifica los datos que ya tienes.

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


update public.clientes
set delivery_date = date
where delivery_date is null and date is not null;
