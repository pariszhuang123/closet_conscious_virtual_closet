create or replace function fetch_clothes_worn_achievement()
returns json
SET search_path = ''
as $$
declare
  clothes_worn boolean;
  current_user_id uuid := auth.uid();
begin
  -- Check if user has 100% clothes worn and has not yet achieved 'all_clothes_worn'
  select
    uhfs.initial_upload_items_worn_percentage >= 99.99
    and not exists (
      select 1
      from public.user_achievements ua
      where ua.user_id = current_user_id
      and ua.achievement_name = 'all_clothes_worn'
    )
  into clothes_worn
  from public.user_high_freq_stats uhfs
  where uhfs.user_id = current_user_id;

  -- Return as JSON
  return json_build_object('status', 'success', 'achievement', clothes_worn);
  end if;
end;
$$ language plpgsql;

create or replace function fetch_milestone_achievements()
returns json
SET search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  current_streak int;
  achieved_milestones jsonb; -- Use jsonb to allow easier filtering
begin
  -- Fetch the user's current streak
  select no_buy_highest_streak into current_streak
  from public.user_high_freq_stats
  where user_id = current_user_id;

  -- Build the milestone achievement JSON in one query
  select jsonb_strip_nulls(jsonb_build_object(
    'no_new_clothes_90',
      case
        when current_streak = 90 and not exists (
          select 1 from public.user_achievements where user_id = current_user_id and achievement_name ? 'no_new_clothes_90'
        ) then true else null end
    ),
    'no_new_clothes_225',
      case
        when current_streak = 225 and not exists (
          select 1 from public.user_achievements where user_id = current_user_id and one_off_features ? 'no_new_clothes_225'
        ) then true else null end
    ),
    'no_new_clothes_405',
      case
        when current_streak = 405 and not exists (
          select 1 from public.user_achievements where user_id = current_user_id and one_off_features ? 'no_new_clothes_405'
        ) then true else null end
    ),
    'no_new_clothes_630',
      case
        when current_streak = 630 and not exists (
          select 1 from public.user_achievements where user_id = current_user_id and one_off_features ? 'no_new_clothes_630'
        ) then true else null end
    ),
    'no_new_clothes_900',
      case
        when current_streak = 900 and not exists (
          select 1 from public.user_achievements where user_id = current_user_id and one_off_features ? 'no_new_clothes_900'
        ) then true else null end
    ),
    'no_new_clothes_1215',
      case
        when current_streak = 1215 and not exists (
          select 1 from public.user_achievements where user_id = current_user_id and one_off_features ? 'no_new_clothes_1215'
        ) then true else null end
    ),
    'no_new_clothes_1575',
      case
        when current_streak = 1575 and not exists (
          select 1 from public.user_achievements where user_id = current_user_id and one_off_features ? 'no_new_clothes_1575'
        ) then true else null end
    ),
  ) into milestone_achievements;

  -- Return the result as a JSON object
  return json_build_object('status', 'success', 'achieved_milestones', achieved_milestones);
end;
$$ language plpgsql;
