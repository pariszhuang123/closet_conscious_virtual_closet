CREATE POLICY "authenticated_select"
ON storage.objects
FOR SELECT
USING (
  auth.role() = 'authenticated'
  AND bucket_id = 'item_pics'
 AND left(name, char_length(auth.uid()::text) + 1) = concat(auth.uid()::text, '/')
);

CREATE POLICY "authenticated_upload"
ON storage.objects
FOR INSERT
WITH CHECK (
  auth.role() = 'authenticated'
  AND bucket_id = 'item_pics'
 AND left(name, char_length(auth.uid()::text) + 1) = concat(auth.uid()::text, '/')
);

CREATE POLICY "authenticated_update"
ON storage.objects
FOR UPDATE
USING (
  auth.role() = 'authenticated'
  AND bucket_id = 'item_pics'
 AND left(name, char_length(auth.uid()::text) + 1) = concat(auth.uid()::text, '/')
);

CREATE POLICY "authenticated_delete"
ON storage.objects
FOR DELETE
USING (
  auth.role() = 'authenticated'
  AND bucket_id = 'item_pics'
  AND left(name, char_length(auth.uid()::text) + 1) = concat(auth.uid()::text, '/')
);
