ALTER TABLE public.items
DROP COLUMN price_per_wear;

ALTER TABLE public.items
ADD COLUMN price_per_wear NUMERIC GENERATED ALWAYS AS (
  CASE
    WHEN worn_in_outfit = 0 THEN amount_spent
    ELSE amount_spent / worn_in_outfit
  END
) STORED;
