-- Run in Supabase > SQL Editor
create table if not exists public.residents (
 room_no integer primary key check (room_no between 1 and 100000),
 name text not null check (char_length(trim(name)) between 1 and 80),
 normalized_name text generated always as (lower(trim(name))) stored unique,
 created_at timestamptz not null default now()
);
alter table public.residents enable row level security;
drop policy if exists "Public can read residents" on public.residents;
create policy "Public can read residents" on public.residents for select to anon, authenticated using (true);
grant select on public.residents to anon, authenticated;

create or replace function public.add_tower_residents(p_names text[])
returns jsonb language plpgsql security definer set search_path=public as $$
declare v_name text; v_room integer; v_added integer:=0; v_duplicates integer:=0; v_full integer:=0;
begin
 if coalesce(auth.jwt()->'app_metadata'->>'role','') <> 'admin' then
   raise exception 'Administrator access required';
 end if;
 perform pg_advisory_xact_lock(74102911);
 foreach v_name in array coalesce(p_names,array[]::text[]) loop
   v_name:=left(trim(v_name),80);
   if v_name='' then continue; end if;
   if exists(select 1 from residents where normalized_name=lower(v_name)) then
     v_duplicates:=v_duplicates+1; continue;
   end if;
   select g into v_room from generate_series(1,100000) g
   where not exists(select 1 from residents r where r.room_no=g) order by g limit 1;
   if v_room is null then v_full:=v_full+1; continue; end if;
   insert into residents(room_no,name) values(v_room,v_name) on conflict do nothing;
   if found then v_added:=v_added+1; else v_duplicates:=v_duplicates+1; end if;
   v_room:=null;
 end loop;
 return jsonb_build_object('added',v_added,'duplicates',v_duplicates,'full',v_full);
end $$;
revoke all on function public.add_tower_residents(text[]) from public;
grant execute on function public.add_tower_residents(text[]) to authenticated;
