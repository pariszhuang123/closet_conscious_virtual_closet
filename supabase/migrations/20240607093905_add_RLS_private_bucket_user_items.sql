-- Enable RLS on the storage.objects table
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Policy: Allow authenticated users to manage their own files
CREATE POLICY "Authenticated users can manage their own files"
ON storage.objects
FOR ALL
USING (
  auth.uid() IS NOT NULL AND
  storage.objects.bucket_id = 'user_items' AND
  storage.objects.owner = auth.uid()
);

-- Policy: Allow authenticated users to read their own files
CREATE POLICY "Authenticated users can read their own files"
ON storage.objects
FOR SELECT
USING (
  auth.uid() IS NOT NULL AND
  storage.objects.bucket_id = 'user_items' AND
  storage.objects.owner = auth.uid()
);

-- Policy: Allow authenticated users to upload files
CREATE POLICY "Authenticated users can upload files"
ON storage.objects
FOR INSERT
WITH CHECK (
  auth.uid() IS NOT NULL AND
  storage.objects.bucket_id = 'user_items' AND
  storage.objects.owner = auth.uid()
);

-- Policy: Allow authenticated users to delete their own files
CREATE POLICY "Authenticated users can delete their own files"
ON storage.objects
FOR DELETE
USING (
  auth.uid() IS NOT NULL AND
  storage.objects.bucket_id = 'user_items' AND
  storage.objects.owner = auth.uid()
);

-- Policy: Allow authenticated users to edit their own files
CREATE POLICY "Authenticated users can edit their own files"
ON storage.objects
FOR UPDATE
USING (
  auth.uid() IS NOT NULL AND
  storage.objects.bucket_id = 'user_items' AND
  storage.objects.owner = auth.uid()
);