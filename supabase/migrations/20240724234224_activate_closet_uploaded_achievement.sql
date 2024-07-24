-- Closet Uploaded Achievement
CREATE OR REPLACE FUNCTION closet_uploaded_achievement()
RETURNS JSON
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    result JSON;
BEGIN
    -- Update the user_achievements table
    INSERT INTO public.user_achievements (user_id, achievement_name)
    VALUES (current_user_id, 'closet_uploaded')
    ON CONFLICT (user_id, achievement_name) DO NOTHING;

    -- Fetch the badge_url and other relevant information from the achievements table
    SELECT json_build_object(
        'badge_url', badge_url
    ) INTO result
    FROM public.achievements
    WHERE achievement_name = 'closet_uploaded';

    -- Return the JSON object
    RETURN result;
END;
$$;
