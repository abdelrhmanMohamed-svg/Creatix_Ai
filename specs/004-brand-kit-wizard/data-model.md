# Data Model: Brand Kit Wizard

## Entities

### BrandKit
Represents a specific brand's complete identity definition containing business type, tone of voice, color palette, target audience, and AI-generated summary.

#### Attributes
- `id`: UUID (Primary Key)
- `brand_id`: UUID (Foreign Key to brands.id, Unique Constraint)
- `business_type`: String (e.g., "restaurant", "tech startup", "consulting")
- `tone_of_voice`: String (e.g., "professional", "friendly", "authoritative", "playful")
- `colors`: List of String (Hexadecimal color codes, e.g., ["#FF5733", "#33FF57"])
- `target_audience`: String (Description of the brand's target audience)
- `ai_summary`: String (AI-generated brand summary based on inputs)
- `created_at`: Timestamp (Record creation time)
- `updated_at`: Timestamp (Last record update time)

#### Relationships
- **One-to-One with Brand**: Each brand has exactly one BrandKit, each BrandKit belongs to exactly one brand
  - Implemented via: Foreign key `brand_id` referencing `brands.id` with UNIQUE constraint
  - Cascade Delete: When a brand is deleted, its associated BrandKit is automatically deleted

#### Validation Rules
- `brand_id`: Required, must reference an existing brand
- `business_type`: Required, must be non-empty string
- `tone_of_voice`: Required, must be non-empty string
- `colors`: Required, must contain at least one valid hexadecimal color code
- `target_audience`: Required, must be non-empty string
- `ai_summary`: Optional on creation, populated during wizard completion
- `created_at`: Automatically set on record creation
- `updated_at`: Automatically updated on record modification

#### State Transitions
1. **Empty State**: No BrandKit exists for a brand (wizard not completed)
2. **In Progress**: User is working through the wizard (data being collected)
3. **Complete**: BrandKit entity exists with all required fields populated
4. **Updated**: Existing BrandKit has been modified via wizard re-run

## Database Schema (Supabase SQL)

```sql
-- BrandKit table (references existing brands table from Phase 3)
create table brand_kits (
  id uuid primary key default gen_random_uuid(),
  brand_id uuid references brands(id) on delete cascade not null unique,
  business_type text not null,
  tone_of_voice text not null,
  colors text[] not null,
  target_audience text not null,
  ai_summary text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable real-time (if needed)
alter publication supabase_realtime add table brand_kits;

-- Updated at trigger (Supabase standard approach)
create trigger update_brand_kits_updated_at
before update on brand_kits
for each row
execute procedure moddatetime (updated_at);
```

## Data Transfer Objects (DTOs)

### BrandKitCreationDTO
Used when creating a new BrandKit through the wizard
- `brand_id`: UUID (required)
- `business_type`: String (required)
- `tone_of_voice`: String (required)
- `colors`: List<String> (required)
- `target_audience`: String (required)

### BrandKitResponseDTO
Used when returning BrandKit data to the frontend
- `id`: UUID
- `brand_id`: UUID
- `business_type`: String
- `tone_of_voice`: String
- `colors`: List<String>
- `target_audience`: String
- `ai_summary`: String?
- `created_at`: Timestamp
- `updated_at`: Timestamp

### BrandKitUpdateDTO
Used when updating an existing BrandKit
- `business_type`: String? (optional, only include if changed)
- `tone_of_voice`: String? (optional, only include if changed)
- `colors`: List<String>? (optional, only include if changed)
- `target_audience`: String? (optional, only include if changed)
- `ai_summary`: String? (optional, only include if changed)

## Indexes
- Primary key on `id`
- Unique constraint on `brand_id` (enforces one-to-one relationship)
- Foreign key index on `brand_id` (automatically created by Supabase)
- Optional: Index on `created_at` for time-based queries

## Security Considerations (RLS Policies)
```sql
-- Enable Row Level Security
alter table brand_kits enable row level security;

-- Policy: Users can only access BrandKits for their own brands
create policy "Users can view own brand kits"
on brand_kits for select
using ( exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
) );

-- Policy: Users can only create BrandKits for their own brands
create policy "Users can create own brand kits"
on brand_kits for insert
with check ( exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
) );

-- Policy: Users can only update BrandKits for their own brands
create policy "Users can update own brand kits"
on brand_kits for update
using ( exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
) )
with check ( exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
) );

-- Policy: Users can only delete BrandKits for their own brands
create policy "Users can delete own brand kits"
on brand_kits for delete
using ( exists (
  select 1 from brands
  where brands.id = brand_kits.brand_id
  and brands.user_id = auth.uid()
) );
```