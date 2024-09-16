create or replace function check_user_access_to_create_outfit()
returns boolean
set search_path = ''
as $$
declare
  has_multi_closet boolean := false;
  daily_upload_status boolean := false;
begin
  -- Fetch both the multi_closet status and daily_upload status in a single query
  select
    coalesce((one_off_feature ? 'multi_closet'), false),
    coalesce(daily_upload, false)
  into has_multi_closet, daily_upload_status
  from public.premium_features pf
  join public.user_high_freq_stats uhfs
    on pf.user_id = uhfs.user_id
  where pf.user_id = auth.uid();

  -- Simplified logic to return true or false
  return (daily_upload_status = false or (daily_upload_status = true and has_multi_closet = true));

exception
  when others then
    -- Optional: log the error or return false if something goes wrong
    return false;
end;
$$ language plpgsql;
