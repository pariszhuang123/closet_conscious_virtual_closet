CREATE OR REPLACE FUNCTION public.check_nps_trigger()
RETURNS TABLE(
    outfits_created INT,
    milestone_triggered BOOLEAN
)
SET search_path = ''
LANGUAGE plpgsql
AS $$
DECLARE
    current_milestone INT;
BEGIN
    -- Calculate the milestone based on the current number of outfits created
    SELECT stats.outfits_created INTO current_milestone
    FROM public.user_high_freq_stats AS stats
    WHERE stats.user_id = auth.uid()
    ORDER BY stats.outfits_created DESC
    LIMIT 1;

    RETURN QUERY
    SELECT
        COALESCE(current_milestone, 0) AS outfits_created,
        CASE
            WHEN current_milestone IN (10, 30, 60, 90, 150, 210, 270, 330, 390, 450, 510, 570, 630, 690, 750, 810, 870, 930, 990, 1050, 1110, 1170, 1230, 1290, 1350, 1410, 1470, 1530, 1590, 1650, 1710, 1770, 1830)  -- List your milestones here
                 AND (reviews.milestone_triggered IS NULL OR reviews.milestone_triggered <> current_milestone)
            THEN TRUE  -- Milestone reached, but not yet triggered, show NPS
            ELSE FALSE -- Milestone not reached or already triggered, do not show NPS
        END AS milestone_triggered
    FROM
        public.user_high_freq_stats AS stats
    LEFT JOIN
        public.user_reviews AS reviews
    ON
        stats.user_id = reviews.user_id
        AND current_milestone = reviews.milestone_triggered
    WHERE
        stats.user_id = auth.uid()
    LIMIT 1;

END;
$$;
