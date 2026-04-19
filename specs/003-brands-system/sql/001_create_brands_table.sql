-- Create brands table for Brands System feature
-- Run this in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS public.brands (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  logo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  
  CONSTRAINT brands_user_id_name_unique UNIQUE (user_id, name)
);

-- Index for faster queries by user_id
CREATE INDEX IF NOT EXISTS idx_brands_user_id ON public.brands(user_id);

-- Index for sorting by created_at
CREATE INDEX IF NOT EXISTS idx_brands_created_at ON public.brands(created_at DESC);

-- Enable Row Level Security
ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only see their own brands
CREATE POLICY "Users can view own brands" ON public.brands
  FOR SELECT
  USING (auth.uid() = user_id);

-- RLS Policy: Users can only insert their own brands
CREATE POLICY "Users can insert own brands" ON public.brands
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS Policy: Users can only update their own brands
CREATE POLICY "Users can update own brands" ON public.brands
  FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS Policy: Users can only delete their own brands
CREATE POLICY "Users can delete own brands" ON public.brands
  FOR DELETE
  USING (auth.uid() = user_id);