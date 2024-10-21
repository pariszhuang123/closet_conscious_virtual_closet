ALTER TABLE public.outfits
ADD COLUMN event_name TEXT NOT NULL DEFAULT 'cc_none';

COMMENT ON COLUMN public.outfits.event_name IS 'The event where the outfit is worn to. cc_none is the default when there is no field that is used for this database';

CREATE TABLE public.app_version (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    version_number TEXT NOT NULL UNIQUE CHECK (version_number ~ '^\d+\.\d+\.\d+$'),
    release_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    min_supported_version TEXT NOT NULL CHECK (min_supported_version ~ '^\d+\.\d+\.\d+$'),
    is_current BOOLEAN DEFAULT FALSE,
    notes TEXT NOT NULL
    );

COMMENT ON TABLE public.app_version IS 'Stores information about app versions, including release date, version status, and update policies.';

COMMENT ON COLUMN public.app_version.id IS 'Primary key for the app version table. A randomly generated UUID.';
COMMENT ON COLUMN public.app_version.version_number IS 'Version number of the app (e.g., 1.0.0). Must be unique and represent the public-facing app version.';
COMMENT ON COLUMN public.app_version.release_date IS 'Timestamp when the app version was released. Default is the current timestamp.';
COMMENT ON COLUMN public.app_version.min_supported_version IS 'The minimum app version supported. Users on versions below this will be prompted to update.';
COMMENT ON COLUMN public.app_version.is_current IS 'Indicates whether this version is the latest and current version. Only one version should have this set to true at any time.';
COMMENT ON COLUMN public.app_version.notes IS 'Release notes or description of updates and changes made in this version.';

