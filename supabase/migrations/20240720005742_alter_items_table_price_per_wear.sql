ALTER TABLE items
ADD COLUMN price_per_wear NUMERIC GENERATED ALWAYS AS (
  CASE
    WHEN worn_in_outfit = 0 THEN 0
    ELSE amount_spent / worn_in_outfit
  END
) STORED;
