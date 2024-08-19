create or replace function public.review_outfit(
  p_outfit_id uuid,
  p_feedback text,
  p_item_ids uuid[],
  p_outfit_comments text default 'cc_none'
)
returns JSON
SET search_path = ''
LANGUAGE plpgsql
as $$
declare
  result JSON;
begin
  -- If feedback is "dislike" or "alright", update the disliked status of the items
  if p_feedback in ('dislike', 'alright') and cardinality(p_item_ids) > 0 then
    update public.outfits_items
    set 
        disliked = true
    where outfit_id = p_outfit_id
    and item_id = any(p_item_ids);
  end if;

  -- Update the outfits table with the feedback and comments
  update public.outfits
  set feedback = p_feedback,
      comments = p_outfit_comments,
      reviewed = true,
      updated_at = NOW()
  where outfit_id = p_outfit_id;

  -- If everything is successful
  result := json_build_object('status', 'success', 'message', 'Review updated successfully', 'outfit_id', p_outfit_id);
  return result;

EXCEPTION
  WHEN OTHERS THEN
    return json_build_object('status', 'error', 'message', 'An unexpected error occurred. Please try again later.');
end;
$$;
