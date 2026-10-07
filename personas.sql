-- 001_personas.sql
-- Separa "persona" de "recibo/medida" SIN romper la versión que usa el cliente.
-- La tabla public.clientes se queda igual (cada fila sigue siendo un recibo);
-- solo se le agrega la columna persona_id. El código actual ignora lo nuevo.
--
-- Probar PRIMERO en el proyecto de pruebas. En producción: respaldo antes.
-- Se puede ejecutar más de una vez sin duplicar datos.

begin;

-- 1) Tabla de personas
create table if not exists public.personas (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text,          -- teléfono tal como se registró (puede traer 2 números)
  phone2 text,         -- teléfono extra (se llenará en registros nuevos)
  birth_date date,     -- para cumpleaños (se irá llenando)
  created_at timestamptz not null default now()
);

alter table public.personas enable row level security;
drop policy if exists "usuarios autenticados" on public.personas;
create policy "usuarios autenticados" on public.personas
  for all to authenticated using (true) with check (true);

-- 2) Cada recibo apunta a su persona
alter table public.clientes
  add column if not exists persona_id uuid references public.personas(id) on delete set null;
create index if not exists idx_clientes_persona_id on public.clientes (persona_id);

-- 3) Relleno de los recibos que ya existen:
--    misma persona = mismo nombre (sin importar mayúsculas/espacios) + mismo teléfono.
--    Los datos de la persona salen de su recibo más reciente.
with grupos as (
  select
    lower(btrim(regexp_replace(coalesce(name,''), '\s+', ' ', 'g')))  as nkey,
    regexp_replace(coalesce(phone,''), '\D', '', 'g')                  as pkey,
    (array_agg(btrim(regexp_replace(name, '\s+', ' ', 'g')) order by coalesce(delivery_date, date) desc nulls last, created_at desc))[1] as name,
    (array_agg(phone        order by coalesce(delivery_date, date) desc nulls last, created_at desc))[1] as phone,
    min(created_at) as created_at
  from public.clientes
  where persona_id is null
    and coalesce(btrim(name),'') <> ''
  group by 1, 2
),
nuevas as (
  insert into public.personas (name, phone, created_at)
  select name, phone, created_at from grupos
  returning id, name, phone
)
update public.clientes c
set persona_id = n.id
from nuevas n
where c.persona_id is null
  and lower(btrim(regexp_replace(coalesce(c.name,''), '\s+', ' ', 'g'))) = lower(btrim(regexp_replace(coalesce(n.name,''), '\s+', ' ', 'g')))
  and regexp_replace(coalesce(c.phone,''), '\D', '', 'g') = regexp_replace(coalesce(n.phone,''), '\D', '', 'g');

commit;

-- 4) Verificación (solo lectura): corre estas consultas y revisa los números
-- select count(*) as recibos from public.clientes;
-- select count(*) as personas from public.personas;
-- select count(*) as recibos_sin_persona from public.clientes where persona_id is null;
-- Personas con más de un recibo (los que ya tienen historial):
-- select p.name, p.phone, count(*) as recibos
-- from public.personas p join public.clientes c on c.persona_id = p.id
-- group by p.id, p.name, p.phone having count(*) > 1 order by recibos desc;