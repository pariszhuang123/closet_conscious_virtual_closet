-- Add the outfits_reviewed column
ALTER TABLE public.user_high_freq_stats
ADD COLUMN outfits_reviewed INT4 NOT NULL DEFAULT 0;

-- Add a comment to describe the purpose of the column
COMMENT ON COLUMN public.user_high_freq_stats.outfits_reviewed IS
'Tracks the total number of outfits reviewed by the user. Default value is 0, and it is a non-nullable column.';

create or replace function public.review_outfit(
  p_outfit_id uuid,
  p_feedback text,
  p_item_ids uuid[],
  p_outfit_comments text default 'cc_none'
)
returns JSON
LANGUAGE plpgsql
SET search_path = ''
as $$
declare
  result JSON;
  current_user_id uuid := auth.uid(); -- Store the authenticated user's ID
begin
  -- Update the disliked status of the items in the outfits_items table
  update public.outfit_items
  set disliked = true
  where outfit_id = p_outfit_id
  and item_id = any(p_item_ids)
  and current_owner_id = current_user_id;

  -- Update the outfits table with the feedback and comments
  update public.outfits
  set feedback = p_feedback,
      outfit_comments = p_outfit_comments,
      reviewed = true,
      updated_at = NOW()
  where outfit_id = p_outfit_id
  and user_id = current_user_id;

  update public.user_high_freq_stats
  set outfits_reviewed = outfits_reviewed+1,
        updated_at = NOW()
  where user_id = current_user_id;

  -- Return success result
  result := json_build_object('status', 'success', 'message', 'Review updated successfully', 'outfit_id', p_outfit_id);
  return result;

  -- Add error handling if necessary
exception when others then
  -- Return a failure message
  result := json_build_object('status', 'failure', 'message', SQLERRM, 'outfit_id', p_outfit_id);
  return result;
end;
$$;
