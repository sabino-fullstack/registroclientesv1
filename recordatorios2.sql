create table if not exists public.recordatorios (
  id uuid primary key default gen_random_uuid(),
  persona_id uuid not null references public.personas(id) on delete cascade,
  tipo text not null check (tipo in ('cumple','control')),
  periodo text not null,   -- cumple: año ("2026"); control: id del recibo
  sent_at timestamptz not null default now(),
  unique (persona_id, tipo, periodo)
);

alter table public.recordatorios enable row level security;
drop policy if exists "usuarios autenticados" on public.recordatorios;
create policy "usuarios autenticados" on public.recordatorios
  for all to authenticated using (true) with check (true);