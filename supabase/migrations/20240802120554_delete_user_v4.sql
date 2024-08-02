CREATE OR REPLACE FUNCTION delete_user_folder_and_account(user_id uuid)
RETURNS void
SET search_path = ''
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  file_record RECORD;
BEGIN
  -- Begin a new transaction
  PERFORM pg_advisory_xact_lock(user_id::bigint);

  -- Loop through and delete each file in the user's folder
  FOR file_record IN
    SELECT name FROM storage.objects
    WHERE bucket_id = 'item_pics' AND name LIKE user_id || '/%'
  LOOP
    BEGIN
      PERFORM storage.delete_object('item_pics', file_record.name);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE NOTICE 'Failed to delete file: %', file_record.name;
        -- Optionally handle the error, log it, or re-raise
    END;
  END LOOP;

  -- Delete the user from auth.users
  DELETE FROM auth.users WHERE id = user_id;

  -- Commit the transaction
  PERFORM pg_advisory_xact_unlock(user_id::bigint);

EXCEPTION
  WHEN OTHERS THEN
    -- Rollback the transaction in case of an error
    PERFORM pg_advisory_xact_unlock(user_id::bigint);
    RAISE;
END;
$$;
