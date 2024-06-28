-- Increment filter requests
CREATE OR REPLACE FUNCTION increment_filter_request(p_user_id uuid)
RETURNS void AS $$
BEGIN
    UPDATE user_low_freq_stats
    SET filter_request = filter_request + 1
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- Increment multi-closet requests
CREATE OR REPLACE FUNCTION increment_multi_closet_request(p_user_id uuid)
RETURNS void AS $$
BEGIN
    UPDATE user_low_freq_stats
    SET multi_closet_request = multi_closet_request + 1
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- Increment analytics request
CREATE OR REPLACE FUNCTION increment_analytics_request(p_user_id uuid)
RETURNS void AS $$
BEGIN
    UPDATE user_low_freq_stats
    SET analytics_request = analytics_request + 1
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;
