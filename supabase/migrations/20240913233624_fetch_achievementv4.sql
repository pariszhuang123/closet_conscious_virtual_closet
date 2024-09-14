create or replace function fetch_clothes_worn_achievement()
returns json
SET search_path = ''
as $$
declare
  clothes_worn boolean;
  current_user_id uuid := auth.uid();
  p_achievement_name constant text := 'all_clothes_worn';
  reward_result json; -- To store the result from the reward function
begin
  -- Check if user has 100% clothes worn and has not yet achieved 'all_clothes_worn'
  select
    uhfs.initial_upload_items_worn_percentage = 100
    and not exists (
      select 1
      from public.user_achievements ua
      where ua.user_id = current_user_id
      and ua.achievement_name = p_achievement_name
    )
  into clothes_worn
  from public.user_high_freq_stats uhfs
  where uhfs.user_id = current_user_id;

  -- If clothes_worn is true, set achievement_name to 'all_clothes_worn'
  if clothes_worn then
    -- Insert the achievement into the user_achievements table
    insert into public.user_achievements (user_id, achievement_name, awarded_at)
    values (current_user_id, p_achievement_name, now());

    -- Call the achievement_milestone_reward function and pass the achievement name
    reward_result := achievement_milestone_reward(p_achievement_name);

    -- If the reward result is not a success, raise an exception to roll back
    if (reward_result->>'status') != 'success' then
      raise exception 'Reward function failed with message: %', reward_result->>'message';
    end if;

    -- Return JSON object with the achievement and reward result
    return json_build_object(
      'status', 'success',
      'achievement', p_achievement_name,
      'reward_result', reward_result
    );
  else
    -- No achievement unlocked, return a more descriptive response
    return json_build_object(
      'status', 'no_achievement',
      'message', 'No achievement unlocked, clothes worn percentage is below 100%'
    );
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
  milestone_name text;
  inserted_achievement jsonb := '{}'::jsonb; -- To store the inserted achievement, if any
  reward_result json; -- To store the reward function result
begin
  -- Fetch the user's current streak
  select no_buy_highest_streak into current_streak
  from public.user_high_freq_stats
  where user_id = current_user_id;

  -- Use a CASE expression to determine the appropriate milestone
  milestone_name := case
    when current_streak = 1575 then 'no_new_clothes_1575'
    when current_streak = 1215 then 'no_new_clothes_1215'
    when current_streak = 900 then 'no_new_clothes_900'
    when current_streak = 630 then 'no_new_clothes_630'
    when current_streak = 405 then 'no_new_clothes_405'
    when current_streak = 225 then 'no_new_clothes_225'
    when current_streak = 90 then 'no_new_clothes_90'
    else null -- No milestone reached
  end;

  -- If a milestone is reached and it hasn't been awarded yet, insert the achievement
  if milestone_name is not null then
    if not exists (
        select 1 from public.user_achievements
        where user_id = current_user_id
        and achievement_name = milestone_name
    ) then
      -- Insert the new milestone achievement
      insert into public.user_achievements (user_id, achievement_name, awarded_at)
      values (current_user_id, milestone_name, now());

      -- Store the inserted achievement in the JSON object
      inserted_achievement := jsonb_build_object('achievement_name', milestone_name);

      -- Call the achievement_milestone_reward function and pass the achievement name
      reward_result := achievement_milestone_reward(milestone_name);

      -- If the reward result is not a success, raise an exception to roll back
      if (reward_result->>'status') != 'success' then
        raise exception 'Reward function failed with message: %', reward_result->>'message';
      end if;
      -- Return success response with achievement and reward details
      return json_build_object(
        'status', 'success',
        'inserted_achievement', inserted_achievement,
        'reward_result', reward_result
      );
    else
      -- Milestone already achieved
      return json_build_object(
        'status', 'no_achievement',
        'message', 'Milestone already achieved'
      );
    end if;
  else
    -- No milestone reached
    return json_build_object(
      'status', 'no_milestone',
      'message', 'No milestone reached for the current streak'
    );
  end if;
end;
$$ language plpgsql;
