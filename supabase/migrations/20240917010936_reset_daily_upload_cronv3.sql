-- Create the function to reset daily uploads and update streaks accordingly
CREATE OR REPLACE FUNCTION reset_daily_uploads()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  reduction_amount CONSTANT INT := 30;
BEGIN
  -- Reset daily uploads for all users
  UPDATE public.user_high_freq_stats
  SET
    daily_upload = false
  WHERE daily_upload = true;

  -- Update no_buy_streak for users who have not created outfits in the last 24 hours
  WITH users_with_no_outfits_yesterday AS (
      SELECT uhfs.user_id, uhfs.no_buy_streak,
        -- Determine the highest milestone achieved by the user
            MAX(CASE WHEN achievement_name = 'no_new_clothes_1575' THEN 1575
                WHEN achievement_name = 'no_new_clothes_1215' THEN 1215
                WHEN achievement_name = 'no_new_clothes_900' THEN 900
                WHEN achievement_name = 'no_new_clothes_630' THEN 630
                WHEN achievement_name = 'no_new_clothes_405' THEN 405
                WHEN achievement_name = 'no_new_clothes_225' THEN 225
                WHEN achievement_name = 'no_new_clothes_90' THEN 90
                ELSE 0
            END) AS previous_milestone
      FROM public.user_high_freq_stats uhfs
      LEFT JOIN public.user_achievements ua
      ON uhfs.user_id = ua.user_id
      LEFT JOIN public.outfits o
      ON o.user_id = uhfs.user_id
      AND o.created_at >= (CURRENT_TIMESTAMP - INTERVAL '24 hours')
      WHERE o.user_id IS NULL
      GROUP BY uhfs.user_id, uhfs.no_buy_streak
  )
  -- Reduce streaks by 30, but ensure it doesn't go below the milestone
  UPDATE public.user_high_freq_stats
  SET
    no_buy_streak = GREATEST(users_with_no_outfits_yesterday.no_buy_streak - reduction_amount, users_with_no_outfits_yesterday.previous_milestone),
    updated_at = NOW() -- Update the timestamp for affected users
  FROM users_with_no_outfits_yesterday
  WHERE public.user_high_freq_stats.user_id = users_with_no_outfits_yesterday.user_id;

END;
$$;
