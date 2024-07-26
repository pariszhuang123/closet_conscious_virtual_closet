create or replace function delete_user_folder_and_account(user_id uuid)
returns void
SET search_path = ''
language plpgsql security definer as $$
begin
  -- Delete all files in the user's folder
  perform storage.delete_object(
    'item_pics',
    objects.name
  )
  from storage.objects
  where bucket_id = 'item_pics'
  and name like user_id || '/%';

  -- Delete the user from auth.users
  perform auth.uid_delete(user_id);

end;
$$;
