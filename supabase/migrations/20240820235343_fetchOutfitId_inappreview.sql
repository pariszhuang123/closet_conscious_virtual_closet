-- Function to fetch outfit_id for a given user
create or replace function public.fetch_outfitId(
  p_user_id uuid
)
returns JSON
LANGUAGE plpgsql
SET search_path = ''
as $$
DECLARE
  v_outfit_id uuid;
  result JSON;
BEGIN
  -- Select the outfit_id based on the specified criteria
  SELECT outfits.outfit_id
  INTO v_outfit_id
  FROM public.outfits
  INNER JOIN public.user_high_freq_stats
        ON outfits.user_id = user_high_freq_stats.user_id
  WHERE outfits.reviewed = false
    AND outfits.user_id = p_user_id
    AND user_high_freq_stats.daily_upload = false
  ORDER BY outfits.updated_at ASC
  LIMIT 1;

  -- Construct the result as a JSON object
  IF v_outfit_id IS NOT NULL THEN
    result := json_build_object(
      'status', 'success',
      'message', 'Successfully obtained outfit_id',
      'outfit_id', v_outfit_id
    );
  ELSE
    result := json_build_object(
      'status', 'failure',
      'message', 'No outfit found for the given criteria'
    );
  END IF;

  RETURN result;

EXCEPTION
  WHEN OTHERS THEN
    result := json_build_object(
      'status', 'error',
      'message', SQLERRM
    );
    RETURN result;
END;
$$;

-- Create a table to track user reviews and NPS scores based on milestone achievements
create table public.user_reviews (
  review_id uuid primary key default uuid_generate_v4(), -- Unique identifier for each review
  user_id uuid not null references user_profiles(id) on delete cascade, -- Foreign key referencing the user who submitted the review
  date_of_review timestamptz not null default current_timestamp, -- Timestamp of when the review was submitted, with timezone
  nps_score int not null default 0 check (nps_score between 0 and 10), -- NPS score or review result, default is 0
  milestone_triggered int not null default 0 -- The milestone (e.g., 30, 90, 270, 540) that triggered the review request, default is 0
);

-- Add comments on the table and its columns
comment on table public.user_reviews is 'Table to track user reviews and NPS scores based on milestone achievements';
comment on column public.user_reviews.review_id is 'Unique identifier for each review';
comment on column public.user_reviews.user_id is 'Foreign key referencing the user who submitted the review';
comment on column public.user_reviews.date_of_review is 'Timestamp of when the review was submitted, stored with timezone';
comment on column public.user_reviews.nps_score is 'NPS score, where detractors are 0-6, passive are 7-8, promoters are 9-10, default is 0';
comment on column public.user_reviews.milestone_triggered is 'The milestone (e.g., 30, 90, 270, 540) that triggered the review request, default is 0';

-- Enable RLS for the user_reviews table
ALTER TABLE public.user_reviews
ENABLE ROW LEVEL SECURITY;

-- Create RLS policies to restrict access to user-specific reviews
CREATE POLICY "Allow user to access own reviews"
ON public.user_reviews
FOR SELECT
TO authenticated
USING (
    user_id = (SELECT auth.uid())
);

CREATE POLICY "Allow user to insert their own reviews"
ON public.user_reviews
FOR INSERT
TO authenticated
WITH CHECK (
    user_id = (SELECT auth.uid())
);

CREATE POLICY "Allow user to update their own reviews"
ON public.user_reviews
FOR UPDATE
TO authenticated
USING (
    user_id = (SELECT auth.uid())
)
WITH CHECK (
    user_id = (SELECT auth.uid())
);

CREATE POLICY "Allow user to delete their own reviews"
ON public.user_reviews
FOR DELETE
TO authenticated
USING (
    user_id = (SELECT auth.uid())
);

-- Function to update the NPS review based on user input
create or replace function public.update_nps_review(
  p_user_id uuid,
  p_nps_score int,
  p_milestone_triggered int
)
returns JSON
LANGUAGE plpgsql
SET search_path = ''
as $$
DECLARE
  result JSON;
BEGIN
  -- Insert or update the NPS score in the user_reviews table
  INSERT INTO public.user_reviews (review_id, user_id, nps_score, milestone_triggered, date_of_review)
  VALUES (uuid_generate_v4(), p_user_id, p_nps_score, p_milestone_triggered, NOW())
  ON CONFLICT (user_id, milestone_triggered)
  DO UPDATE SET
    nps_score = EXCLUDED.nps_score,
    date_of_review = EXCLUDED.date_of_review;

  -- Return success result
  result := json_build_object(
    'status', 'success',
    'message', 'NPS review updated successfully',
    'user_id', p_user_id,
    'nps_score', p_nps_score,
    'milestone_triggered', p_milestone_triggered
  );
  RETURN result;

EXCEPTION
  WHEN OTHERS THEN
    -- Return a failure message
    result := json_build_object(
      'status', 'failure',
      'message', SQLERRM,
      'user_id', p_user_id
    );
    RETURN result;
END;
$$;
