-- Drop existing policies
DROP POLICY IF EXISTS "authenticated_select" ON storage.objects;
DROP POLICY IF EXISTS "authenticated_upload" ON storage.objects;
DROP POLICY IF EXISTS "authenticated_update" ON storage.objects;
DROP POLICY IF EXISTS "authenticated_delete" ON storage.objects;

-- Create new SELECT policy
CREATE POLICY "authenticated_select"
ON storage.objects
FOR SELECT
USING (
  auth.role() = 'authenticated'
  AND bucket_id = 'item_pics'
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Create new INSERT policy
CREATE POLICY "authenticated_upload"
ON storage.objects
FOR INSERT
WITH CHECK (
  bucket_id = 'item_pics'
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Create new UPDATE policy
CREATE POLICY "authenticated_update"
ON storage.objects
FOR UPDATE
USING (
  auth.role() = 'authenticated'
  AND bucket_id = 'item_pics'
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Create new DELETE policy
CREATE POLICY "authenticated_delete"
ON storage.objects
FOR DELETE
USING (
  auth.role() = 'authenticated'
  AND bucket_id = 'item_pics'
  AND auth.uid()::text = (storage.foldername(name))[1]
);
