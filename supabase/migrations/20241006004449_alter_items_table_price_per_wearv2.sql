ALTER TABLE public.items
ALTER COLUMN price_per_wear SET DATA TYPE NUMERIC GENERATED ALWAYS AS (
  CASE
    WHEN worn_in_outfit = 0 THEN amount_spent
    ELSE amount_spent / worn_in_outfit
  END
) STORED;

