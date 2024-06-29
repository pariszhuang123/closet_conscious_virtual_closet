-- Increment multi-closet requests
CREATE OR REPLACE FUNCTION increment_multi_closet_request(p_user_id uuid)
    RETURNS void
    SET search_path = ''
AS $$

BEGIN
    UPDATE user_low_freq_stats
    SET multi_closet_request = multi_closet_request + 1
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;
