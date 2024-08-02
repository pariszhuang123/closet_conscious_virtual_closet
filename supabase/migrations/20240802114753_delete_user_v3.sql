CREATE OR REPLACE FUNCTION delete_user_folder_and_account(user_id uuid)
RETURNS void
SET search_path = ''
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  file_record RECORD;
BEGIN
  -- Loop through and delete each file in the user's folder
  FOR file_record IN
    SELECT name FROM storage.objects
    WHERE bucket_id = 'item_pics' AND name LIKE user_id || '/%'
  LOOP
    PERFORM storage.delete_object('item_pics', file_record.name);
  END LOOP;

  -- Delete the user from auth.users
  DELETE FROM auth.users WHERE id = user_id;

END;
$$;
