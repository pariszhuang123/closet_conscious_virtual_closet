-- Drop existing policies
DROP POLICY "Allow owner to modify swaps" ON swaps;
DROP POLICY "Allow new owner to modify completed swaps" ON swaps;

-- Create the new combined policy
CREATE POLICY "Allow owners to modify swaps"
ON swaps
FOR UPDATE
USING (
  (  (( SELECT auth.uid() AS uid) = owner_id) AND status != 'completed') OR
  (  (( SELECT auth.uid() AS uid) = new_owner_id) AND status = 'completed')
);
