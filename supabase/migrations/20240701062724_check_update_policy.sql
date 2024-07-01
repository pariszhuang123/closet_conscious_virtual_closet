-- Policy for "Allow user to modify own disliked outfit items"
alter policy "Allow user to modify own disliked outfit items"
on "public"."disliked_outfit_items"
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
)
with check (
  (SELECT auth.uid() AS uid) = user_id
);

-- Policy for "Allow user to modify own items"
alter policy "Allow user to modify own items"
on "public"."items"
to authenticated
using (
  (SELECT auth.uid() AS uid) = current_owner_id
)
with check (
  (SELECT auth.uid() AS uid) = current_owner_id
);

-- Policy for "accessory_basic_update_policy"
alter policy "accessory_basic_update_policy"
on "public"."items_accessory_basic"
to authenticated
using (
  (SELECT auth.uid() AS uid) = current_owner_id
)
with check (
  (SELECT auth.uid() AS uid) = current_owner_id
);

-- Policy for "clothing_basic_update_policy"
alter policy "clothing_basic_update_policy"
on "public"."items_clothing_basic"
to authenticated
using (
  (SELECT auth.uid() AS uid) = current_owner_id
)
with check (
  (SELECT auth.uid() AS uid) = current_owner_id
);

-- Policy for "shoes_basic_update_policy"
alter policy "shoes_basic_update_policy"
on "public"."items_shoes_basic"
to authenticated
using (
  (SELECT auth.uid() AS uid) = current_owner_id
)
with check (
  (SELECT auth.uid() AS uid) = current_owner_id
);

-- Policy for "Allow user to modify own outfit items"
alter policy "Allow user to modify own outfit items"
on "public"."outfit_items"
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
)
with check (
  (SELECT auth.uid() AS uid) = user_id
);

-- Policy for "Allow user to modify own outfits"
alter policy "Allow user to modify own outfits"
on "public"."outfits"
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
)
with check (
  (SELECT auth.uid() AS uid) = user_id
);

-- Policy for "Allow user to modify own premium services"
alter policy "Allow user to modify own premium services"
on "public"."premium_services"
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
)
with check (
  (SELECT auth.uid() AS uid) = user_id
);

-- Policy for "Allow owners to modify swaps"
alter policy "Allow owners to modify swaps"
on "public"."swaps"
to public
using (
  (((SELECT auth.uid() AS uid) = owner_id) AND (status <> 'completed'::text))
  OR (((SELECT auth.uid() AS uid) = new_owner_id) AND (status = 'completed'::text))
)
with check (
  (((SELECT auth.uid() AS uid) = owner_id) AND (status <> 'completed'::text))
  OR (((SELECT auth.uid() AS uid) = new_owner_id) AND (status = 'completed'::text))
);

-- Policy for "Allow user to modify own goals"
alter policy "Allow user to modify own goals"
on "public"."user_goals"
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
)
with check (
  (SELECT auth.uid() AS uid) = user_id
);

-- Policy for "Allow user to modify own high freq stats"
alter policy "Allow user to modify own high freq stats"
on "public"."user_high_freq_stats"
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
)
with check (
  (SELECT auth.uid() AS uid) = user_id
);

-- Policy for "Allow user to modify own low freq stats"
alter policy "Allow user to modify own low freq stats"
on "public"."user_low_freq_stats"
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
)
with check (
  (SELECT auth.uid() AS uid) = user_id
);

-- Policy for "Allow individual user update"
alter policy "Allow individual user update"
on "public"."user_profiles"
to authenticated
using (
  (SELECT auth.uid() AS uid) = id
)
with check (
  (SELECT auth.uid() AS uid) = id
);
