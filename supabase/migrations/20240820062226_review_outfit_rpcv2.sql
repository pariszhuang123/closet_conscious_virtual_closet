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
begin
  -- Update the disliked status of the items in the outfits_items table
  update public.outfits_items
  set disliked = true
  where outfit_id = p_outfit_id
  and item_id = any(p_item_ids);

  -- Update the outfits table with the feedback and comments
  update public.outfits
  set feedback = p_feedback,
      comments = p_outfit_comments,
      reviewed = true,
      updated_at = NOW()
  where outfit_id = p_outfit_id;

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
