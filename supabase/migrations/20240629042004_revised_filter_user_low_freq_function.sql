-- Increment filter requests
CREATE OR REPLACE FUNCTION increment_filter_request(p_user_id uuid)
    RETURNS void
    SET search_path = 'public.user_low_freq_stats' as $$

BEGIN
    UPDATE public.user_low_freq_stats
    SET filter_request = filter_request + 1
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;
