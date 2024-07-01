alter policy "Allow user to modify own challenges"
on "public"."challenges"
to authenticated
using (
  (SELECT auth.uid() AS uid) = user_id
)
with check (
  (SELECT auth.uid() AS uid) = user_id
);
