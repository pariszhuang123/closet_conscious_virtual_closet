create or replace function check_user_access_to_access_customize_page()
returns boolean
SET search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();  -- Get the current authenticated user ID
begin
    return (
        select case
            when ps.one_off_features ? 'com.makinglifeeasie.closetconscious.arrange' then true
            else false
        end
        from public.premium_services ps
        where ps.user_id = current_user_id
    );
end;
$$ language plpgsql;

create or replace function check_user_access_to_access_filter_page()
returns boolean
SET search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();  -- Get the current authenticated user ID
begin
    return (
        select case
            when ps.one_off_features ? 'com.makinglifeeasie.closetconscious.filter' then true
            else false
        end
        from public.premium_services ps
        where ps.user_id = current_user_id
    );
end;
$$ language plpgsql;

create or replace function check_user_access_to_access_multi_closet_page()
returns boolean
SET search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();  -- Get the current authenticated user ID
begin
    return (
        select case
            when ps.one_off_features ? 'com.makinglifeeasie.closetconscious.multicloset' then true
            else false
        end
        from public.premium_services ps
        where ps.user_id = current_user_id
    );
end;
$$ language plpgsql;

create or replace function check_user_access_to_access_calendar_page()
returns boolean
SET search_path = ''
as $$
declare
    current_user_id uuid := auth.uid();  -- Get the current authenticated user ID
begin
    return (
        select case
            when ps.one_off_features ? 'com.makinglifeeasie.closetconscious.calendar' then true
            else false
        end
        from public.premium_services ps
        where ps.user_id = current_user_id
    );
end;
$$ language plpgsql;
