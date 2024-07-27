create or replace function delete_user_folder_and_account(user_id uuid)
returns void
SET search_path = ''
language plpgsql security definer as $$
declare
  file_record record;
begin
  -- Loop through and delete each file in the user's folder
  for file_record in
    select name from storage.objects
    where bucket_id = 'item_pics' and name like user_id || '/%'
  loop
    perform storage.delete_object('item_pics', file_record.name);
  end loop;

  -- Delete the user from auth.users
  perform auth.uid_delete(user_id);

end;
$$;
