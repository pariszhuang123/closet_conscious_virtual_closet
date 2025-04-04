CREATE TABLE public.tutorial_progress (
  user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  tutorial_name TEXT NOT NULL,
  interaction_count INTEGER NOT NULL DEFAULT 1,
  tutorial_type TEXT NOT NULL CHECK (tutorial_type IN ('free', 'paid', 'scenario')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, tutorial_name)
);

COMMENT ON TABLE public.tutorial_progress IS
'Tracks individual user interactions with specific tutorials.
Each row represents a unique (user_id, tutorial_name) pair,
used for onboarding, feature walkthroughs, or tutorial gating logic.';

-- 📝 Column comments
COMMENT ON COLUMN public.tutorial_progress.user_id IS
'The UUID of the user from user profile id who interacted with the tutorial.';

COMMENT ON COLUMN public.tutorial_progress.tutorial_name IS
'The identifier for the tutorial (e.g., "free_upload_camera"). Acts as part of the composite primary key.';

COMMENT ON COLUMN public.tutorial_progress.interaction_count IS
'How many times the user interacted with or triggered the tutorial. Used to track usage frequency.';

COMMENT ON COLUMN public.tutorial_progress.tutorial_type IS
'Categorizes the tutorial as "free", "paid", or "scenario". Used to differentiate types of onboarding or feature education.';

COMMENT ON COLUMN public.tutorial_progress.created_at IS
'Timestamp (with timezone) of when the tutorial record was first inserted.';

COMMENT ON COLUMN public.tutorial_progress.updated_at IS
'Timestamp (with timezone) of the most recent update to this record, e.g. when interaction_count is incremented.';

ALTER TABLE public.tutorial_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own tutorial progress"
ON public.tutorial_progress
FOR SELECT
TO authenticated
USING (
  (( SELECT auth.uid() AS uid) = user_id)
);

CREATE POLICY "Users can delete their own tutorial progress"
 ON public.tutorial_progress
 FOR DELETE
 TO authenticated
 USING (
   (( SELECT auth.uid() AS uid) = user_id)
 );

CREATE POLICY "Users can insert their own tutorial progress"
ON public.tutorial_progress
FOR INSERT
TO authenticated
WITH CHECK (
  (( SELECT auth.uid() AS uid) = user_id)
);

CREATE POLICY "Users can update their own tutorial progress"
ON public.tutorial_progress
FOR UPDATE
TO authenticated
USING (
  (( SELECT auth.uid() AS uid) = user_id)
WITH CHECK (
  (( SELECT auth.uid() AS uid) = user_id)
);


create or replace function track_tutorial_interaction(tutorial_input text)
returns boolean
language plpgsql
set search_path = ''
as $$
declare
  current_user_id uuid := auth.uid();
  tutorial_type_value text;
  exists_already boolean;
begin
  -- Determine the tutorial_type based on the tutorial_input
  case tutorial_input
    when 'free_upload_camera' then tutorial_type_value := 'free';
    when 'free_upload_photo_library' then tutorial_type_value := 'free';
    when 'free_edit_camera' then tutorial_type_value := 'free';
    when 'free_create_outfit' then tutorial_type_value := 'free';
    when 'free_closet_upload' then tutorial_type_value := 'free';
    when 'free_info_hub' then tutorial_type_value := 'free';
    when 'paid_filter' then tutorial_type_value := 'paid';
    when 'paid_customize' then tutorial_type_value := 'paid';
    when 'paid_multi_closet' then tutorial_type_value := 'paid';
    when 'paid_calendar' then tutorial_type_value := 'paid';
    when 'paid_usage_analytics' then tutorial_type_value := 'paid';
    else
      raise exception 'Unknown tutorial name: %', tutorial_input;
  end case;

  -- Check if the record already exists
  select exists (
    select 1 from tutorial_progress
    where user_id = current_user_id and tutorial_name = tutorial_input
  ) into exists_already;

  if exists_already then
    -- If exists, update interaction_count and updated_at
    update tutorial_progress
    set interaction_count = interaction_count + 1,
        updated_at = now()
    where user_id = current_user_id and tutorial_name = tutorial_input;

    return true; -- means it's a repeated interaction
  else
    -- If not exists, insert new record
    insert into tutorial_progress (user_id, tutorial_name, tutorial_type)
    values (current_user_id, tutorial_input, tutorial_type_value);

    return false; -- means it's the first interaction
  end if;
end;
$$;
