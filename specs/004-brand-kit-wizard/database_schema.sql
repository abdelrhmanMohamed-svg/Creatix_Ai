-- Brand Kit Wizard Database Schema
-- Execute this in your Supabase SQL editor

-- Step 1: Create table only if not exists
create table if not exists brand_kits (
  id uuid primary key default gen_random_uuid(),
  brand_id uuid references brands(id) on delete cascade not null unique,
  business_type text not null,
  tone_of_voice text not null,
  colors text[] not null,
  target_audience text not null,
  brand_summary text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Step 2: Enable real-time (safe to run again)
alter publication supabase_realtime add table brand_kits;

-- Step 3: Create or replace trigger function
create or replace function update_timestamp()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- Drop and recreate trigger (safe)
drop trigger if exists update_brand_kits_timestamp on brand_kits;
create trigger update_brand_kits_timestamp
before update on brand_kits
for each row
execute function update_timestamp();

-- Step 4: Enable RLS (safe)
alter table brand_kits enable row level security;

-- Step 5: Drop existing policies (safe to run even if they don't exist)
drop policy if exists "Users can view own brand kits" on brand_kits;
drop policy if exists "Users can create own brand kits" on brand_kits;
drop policy if exists "Users can update own brand kits" on brand_kits;
drop policy if exists "Users can delete own brand kits" on brand_kits;

-- Step 6: Create RLS policies
create policy "Users can view own brand kits"
on brand_kits for select
using (exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
));

create policy "Users can create own brand kits"
on brand_kits for insert
with check (exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
));

create policy "Users can update own brand kits"
on brand_kits for update
using (exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
))
with check (exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
));

create policy "Users can delete own brand kits"
on brand_kits for delete
using (exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
));

-- Step 7: Create indexes (safe)
create index if not exists brand_kits_created_at_idx on brand_kits(created_at);
create index if not exists brand_kits_brand_id_idx on brand_kits(brand_id);

-- Step 8: Add foreign key (handle if already exists)
do $$
begin
  if not exists (
    select 1 from information_schema.table_constraints
    where constraint_name = 'brand_kits_brand_id_fkey'
  ) then
    alter table brand_kits
    add constraint brand_kits_brand_id_fkey
    foreign key (brand_id)
    references brands(id)
    on delete cascade;
  end if;
end
$$;

-- Step 9: Helper functions (use or replace)
create or replace function has_brand_kit(p_brand_id uuid)
returns boolean as $$
begin
  return exists (
    select 1 from brand_kits
    where brand_id = p_brand_id
  );
end;
$$ language plpgsql;

create or replace function get_brand_kit_by_brand(p_brand_id uuid)
returns setof brand_kits as $$
begin
  return query (
    select * from brand_kits
    where brand_id = p_brand_id
  );
end;
$$ language plpgsql;