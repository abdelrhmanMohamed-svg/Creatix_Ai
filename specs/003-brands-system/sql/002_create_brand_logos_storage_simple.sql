-- Simple storage policy for brand_logos bucket
-- Run this in Supabase SQL Editor to allow authenticated users to upload

-- Option 1: If bucket exists, just add policies
-- This allows any authenticated user to upload their own files

-- Allow authenticated users to upload to brand_logos
CREATE POLICY "Allow authenticated uploads" ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'brand_logos');

-- Allow authenticated users to select/view brand_logos files
CREATE POLICY "Allow authenticated select" ON storage.objects
FOR SELECT
TO authenticated
USING (bucket_id = 'brand_logos');

-- Allow authenticated users to update own brand_logos files  
CREATE POLICY "Allow authenticated update" ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'brand_logos');

-- Allow authenticated users to delete brand_logos files
CREATE POLICY "Allow authenticated delete" ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'brand_logos');

-- Make bucket public for reading (so logos display in app)
-- Note: Alternatively set bucket to "public" in Supabase dashboard Storage settings