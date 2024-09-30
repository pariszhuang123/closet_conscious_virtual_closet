create or replace function check_user_access_to_create_outfit()
returns boolean
SET search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();  -- Get the current authenticated user ID
begin
    -- Combine both tables and use CASE for the logic
    return (
        select case
            when uhs.daily_upload = true and ps.one_off_features ? 'multi_outfit' then true
            when uhs.daily_upload = false then true
            else false
        end
        from public.user_high_freq_stats uhs
        join public.premium_services ps
        on uhs.user_id = ps.user_id
        where uhs.user_id = current_user_id
    );
end;
$$ language plpgsql;

