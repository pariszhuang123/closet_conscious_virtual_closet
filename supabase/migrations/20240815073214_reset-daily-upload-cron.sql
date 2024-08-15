-- Create the function to reset daily uploads
CREATE OR REPLACE FUNCTION reset_daily_uploads()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$

BEGIN
  UPDATE public.user_high_freq_stats
  SET daily_upload = false;
END;
$$;

-- Schedule the cron job to run the function at 2:00 AM UTC daily
SELECT cron.schedule(
  'reset_daily_uploads_job',  -- Job name
  '0 2 * * *',                -- Cron expression for 2:00 AM UTC daily
  'SELECT reset_daily_uploads();'  -- Command to execute
);
