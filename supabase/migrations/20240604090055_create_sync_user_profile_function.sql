-- inserts a row into public.profiles
create function public.sync_user_profile()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.user_profiles (id, email, name, role, created_at, updated_at)
  values (new.id, new.raw_user_meta_data ->> 'name', new.email, 'authenticated', now(), now());
  return new;
end;
$$;

-- trigger the function every time a user is created
create trigger create_user_profile
  after insert on auth.users
  for each row execute procedure public.sync_user_profile();