-- Increment filter requests
CREATE OR REPLACE FUNCTION increment_filter_request()
RETURNS void AS $$
DECLARE
  current_user_id uuid := auth.uid();
BEGIN
    UPDATE user_low_freq_stats
    SET filter_request = filter_request + 1
    WHERE user_id = current_user_id;
END;
$$ LANGUAGE plpgsql;

-- Increment multi-closet requests
CREATE OR REPLACE FUNCTION increment_multi_closet_request()
RETURNS void AS $$
DECLARE
  current_user_id uuid := auth.uid();
BEGIN
    UPDATE user_low_freq_stats
    SET multi_closet_request = multi_closet_request + 1
    WHERE user_id = current_user_id;
END;
$$ LANGUAGE plpgsql;

-- Increment analytics request
CREATE OR REPLACE FUNCTION increment_analytics_request()
RETURNS void AS $$
DECLARE
  current_user_id uuid := auth.uid();
BEGIN
    UPDATE user_low_freq_stats
    SET analytics_request = analytics_request + 1
    WHERE user_id = current_user_id;
END;
$$ LANGUAGE plpgsql;

-- Increment items swapped
CREATE OR REPLACE FUNCTION increment_items_swapped()
RETURNS void AS $$
DECLARE
  current_user_id uuid := auth.uid();
BEGIN
    UPDATE user_low_freq_stats
    SET items_swapped = items_swapped + 1
    WHERE user_id = current_user_id;
END;
$$ LANGUAGE plpgsql;

-- Increment items sold
CREATE OR REPLACE FUNCTION increment_items_sold()
RETURNS void AS $$
DECLARE
  current_user_id uuid := auth.uid();
BEGIN
    UPDATE user_low_freq_stats
    SET items_sold = items_sold + 1
    WHERE user_id = current_user_id;
END;
$$ LANGUAGE plpgsql;

-- Increment items gifted
CREATE OR REPLACE FUNCTION increment_items_gifted()
RETURNS void AS $$
DECLARE
  current_user_id uuid := auth.uid();
BEGIN
    UPDATE user_low_freq_stats
    SET items_gifted = items_gifted + 1
    WHERE user_id = current_user_id;
END;
$$ LANGUAGE plpgsql;
