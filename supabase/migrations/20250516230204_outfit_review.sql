-- Add the disliked_count column to track how many times an item was disliked
ALTER TABLE public.items
ADD COLUMN disliked_count INTEGER NOT NULL DEFAULT 0;

-- Add a comment to explain the purpose of the column
COMMENT ON COLUMN public.items.disliked_count IS 'Number of times this item was selected as disliked in outfit reviews.';

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
  if p_item_ids is not null and array_length(p_item_ids, 1) > 0 then
    -- Mark outfit items as disliked
    update public.outfit_items
    set disliked = true
    where outfit_id = p_outfit_id
    and item_id = any(p_item_ids);

    -- Increment the dislike count in public.items
    update public.items
    set
        disliked_count = disliked_count +1,
        updated_at = NOW()
    where item_id = any(p_item_ids);
  end if;

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
