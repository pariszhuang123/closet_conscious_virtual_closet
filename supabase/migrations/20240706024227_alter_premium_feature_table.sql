BEGIN;

-- Drop primary key constraint
ALTER TABLE premium_services DROP CONSTRAINT premium_services_pkey;

-- Drop columns
ALTER TABLE premium_services
DROP COLUMN premium_id,
DROP COLUMN service_type,
DROP COLUMN sub_service,
DROP COLUMN activation_date,
DROP COLUMN status;

-- Update columns to be NOT NULL
ALTER TABLE premium_services
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL;

-- Add new columns with default values
ALTER TABLE premium_services
ADD COLUMN one_off_features jsonb NOT NULL DEFAULT '{}',
ADD COLUMN usage_feature jsonb NOT NULL DEFAULT '{}',
ADD COLUMN challenge_feature jsonb NOT NULL DEFAULT '{}';

COMMIT;
