CREATE OR REPLACE FUNCTION public.fetch_user_achievements()
RETURNS json
SET search_path = ''
LANGUAGE sql
AS $$

  select coalesce(
    json_agg(
      json_build_object(
        'achievement_name', a.achievement_name,
        'badge_url', a.badge_url,
        'awarded_at', ua.awarded_at::date
      )
    ), '[]'::json  -- Return an empty array if no achievements are found
  )
  from public.user_achievements ua
  join public.achievements a on ua.achievement_id = a.id
  where ua.user_id = auth.uid();
$$;

