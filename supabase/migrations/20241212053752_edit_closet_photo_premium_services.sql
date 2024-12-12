ALTER TABLE public.user_high_freq_stats
ADD COLUMN closets_edited integer NOT NULL DEFAULT 0;

COMMENT ON COLUMN public.user_high_freq_stats.closets_edited IS 'The number of closet photos taken by the user.';

-- Function to update_edit_item_photo
CREATE OR REPLACE FUNCTION public.update_closet_photo(
  _image_url text,
  _closet_id uuid
)
RETURNS json
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
  current_user_id uuid := auth.uid();
BEGIN
    -- Update the outfits table
    UPDATE public.user_closets
    SET
        image_url = _image_url,
        updated_at = NOW()
    WHERE closet_id = _closet_id AND user_id = current_user_id;

    -- Update user_high_freq_stats table
    UPDATE public.user_high_freq_stats
    SET
        closets_edited = closets_edited + 1,
        updated_at = NOW()
    WHERE user_id = current_user_id;

    -- Return success response with a custom message
    RETURN json_build_object('status', 'success', 'message', 'You have successfully edited your closet photo.');
END;
$$;

CREATE OR REPLACE FUNCTION check_user_access_to_edit_closets()
RETURNS JSON
SET search_path = ''
AS $$
DECLARE
    current_user_id UUID := auth.uid();  -- Get the current authenticated user ID
BEGIN
    -- Combine both tables and use CASE for the logic
    RETURN (
        SELECT CASE
            -- Check for Bronze edit feature
            WHEN uhs.closets_edited = 100 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.bronzeclosetphoto' THEN
                json_build_object('status', 'editClosetBronze')

            -- Check for Silver edit feature
            WHEN uhs.closets_edited = 300 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.silverclosetphoto' THEN
                json_build_object('status', 'editClosetSilver')

            -- Check for Gold edit feature
            WHEN uhs.closets_edited = 1000 AND NOT ps.one_off_features ? 'com.makinglifeeasie.closetconscious.goldclosetphoto' THEN
                json_build_object('status', 'editClosetGold')

            -- Default case if none match
            ELSE
                json_build_object('status', 'no_navigation')
        END
        FROM public.user_high_freq_stats uhs
        JOIN public.premium_services ps
        ON uhs.user_id = ps.user_id
        WHERE uhs.user_id = current_user_id
    );
END;
$$ LANGUAGE plpgsql;


