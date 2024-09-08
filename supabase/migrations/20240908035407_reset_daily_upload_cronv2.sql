-- Create the function to reset daily uploads
CREATE OR REPLACE FUNCTION reset_daily_uploads()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = '' -- Use explicit schema
AS $$

BEGIN
  -- Reset daily uploads for all users
  UPDATE public.user_high_freq_stats
  SET
    daily_upload = false;

  -- Update no_buy_streak to 0 for users who have not created outfits in the last 24 hours
  WITH users_with_no_outfits_yesterday AS (
      SELECT uhfs.user_id
      FROM public.user_high_freq_stats uhfs
      LEFT JOIN public.outfits o
      ON o.user_id = uhfs.user_id
      AND o.created_at >= (CURRENT_TIMESTAMP - INTERVAL '24 hours')
      WHERE o.user_id IS NULL -- Users with no outfits in the last 24 hours
  )
  UPDATE public.user_high_freq_stats
  SET
      no_buy_streak = 0,
      updated_at = NOW() -- Update the timestamp for affected users
  WHERE user_id IN (SELECT user_id FROM users_with_no_outfits_yesterday);

END;
$$;
