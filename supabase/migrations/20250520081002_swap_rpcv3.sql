create or replace function transfer_item_ownership(
  p_item_id uuid,
  p_new_owner_id uuid
)
returns boolean
language plpgsql
security definer
SET search_path = ''
as $$
declare
  v_current_owner_id uuid;
  v_new_default_closet_id uuid;
begin
  -- Attempt to get current owner
  select current_owner_id
  into v_current_owner_id
  from public.items
  where item_id = p_item_id;

  -- If no such item found
  if not found then
    return false;
  end if;

  -- Prevent self-transfer
  if v_current_owner_id = p_new_owner_id then
    return false;
  end if;

  -- Step 3: Get new owner's default closet (sorted by id ascending)
  select closet_id
  into v_new_default_closet_id
  from public.user_closets
  where user_id = p_new_owner_id
    and closet_name = 'cc_closet'
  order by created_at asc
  limit 1;

  if not found then
    return false;
  end if;

  -- Insert into item_transfers
  insert into public.item_transfers (
    item_id,
    from_user,
    to_user
  ) values (
    p_item_id,
    v_current_owner_id,
    p_new_owner_id
  );

  -- Update the current owner
  update public.items
  set current_owner_id =
      p_new_owner_id,
      closet_id = v_new_default_closet_id,
      updated_at = now()
  where item_id = p_item_id;

  return true;
end;
$$;
