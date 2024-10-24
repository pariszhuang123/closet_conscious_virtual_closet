CREATE TABLE public.user_closets (
    closet_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users_profiles(id) ON DELETE CASCADE,
    closet_name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    type TEXT NOT NULL CHECK (type IN ('permanent', 'disappear')),
    status TEXT NOT NULL CHECK (status IN ('active', 'inactive')),
    valid_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table for shared preferences
CREATE TABLE public.shared_preferences(
   user_id UUID REFERENCES public.users_profiles(id) ON DELETE CASCADE,
   filter JSONB NOT NULL DEFAULT '{}',
   closet_id UUID NOT NULL REFERENCES public.user_closets(closet_id),
   created_at TIMESTAMPTZ DEFAULT NOW(),
   updated_at TIMESTAMPTZ DEFAULT NOW(),
   all_closet BOOLEAN NOT NULL DEFAULT FALSE,
   grid INT NOT NULL DEFAULT 3 CHECK (grid between 2 and 7),
   sort TEXT NOT NULL DEFAULT 'updated_at' CHECK (sort IN ('updated_at', 'created_at', 'amount_spent', 'item_last_worn', 'worn_in_outfit', 'price_per_wear')),
   order TEXT NOT NULL DEFAULT 'desc' CHECK (order IN ('desc', 'asc'))
);

CREATE INDEX idx_shared_preference_filter ON public.shared_preferences USING GIN (filter);

-- Table to store user-specific closets, which may be either permanent or temporary (disappear for a period).
COMMENT ON TABLE public.user_closets IS 'Stores user closets, each closet can be of type permanent or disappear, associated with a user.';

-- Closet ID: Unique identifier for each closet.
COMMENT ON COLUMN public.user_closets.closet_id IS 'Primary key: Unique identifier for each closet, auto-generated UUID.';

-- User ID: Links the closet to a user.
COMMENT ON COLUMN public.user_closets.user_id IS 'Foreign key to users_profiles table. Links this closet to the owner (user).';

-- Closet Name: Name assigned by the user for each closet.
COMMENT ON COLUMN public.user_closets.closet_name IS 'User-defined name for the closet (e.g., "Summer Wardrobe"). Each user will have a unique default closet ("cc_closet").';

-- Updated At: Timestamp of when the closet was last updated.
COMMENT ON COLUMN public.user_closets.updated_at IS 'Timestamp when the closet was last updated. Defaults to the current time.';

-- Created At: Timestamp of when the closet was created.
COMMENT ON COLUMN public.user_closets.created_at IS 'Timestamp when the closet was created. Defaults to the current time.';

-- Type: Closet type, either permanent or disappear.
COMMENT ON COLUMN public.user_closets.type IS 'Defines the type of closet: permanent (always visible) or disappear (hidden until valid_date).';

-- Status: Closet status, either active or inactive.
COMMENT ON COLUMN public.user_closets.status IS 'Defines the type of closet: active or inactive. Once inactive, the items within the closet, will move back to default closet ("cc_closet").';

-- Valid Date: When the closet becomes valid (only relevant for disappearing closets).
COMMENT ON COLUMN public.user_closets.valid_date IS 'For disappear-type closets, defines the date when the closet becomes visible and will convert to a permanent closet.';

-- Table to store user-specific preferences for how their closet is displayed and filtered.
COMMENT ON TABLE public.shared_preferences IS 'Stores user-defined preferences for displaying, filtering, and sorting closets.';

-- User ID: Links the preference to a user.
COMMENT ON COLUMN public.shared_preferences.user_id IS 'Foreign key to users_profiles table. Links the preferences to the user.';

-- Filter: JSON object storing the filtering options for closets.
COMMENT ON COLUMN public.shared_preferences.filter IS 'JSON object storing filtering preferences for closets, defaulting to an empty object ({}).';

-- Closet ID: Identifies which closet these preferences apply to.
COMMENT ON COLUMN public.shared_preferences.closet_id IS 'Foreign key to closets table. Links the preferences to a specific closet.';

-- Created At: Timestamp of when the preference was created.
COMMENT ON COLUMN public.shared_preferences.created_at IS 'Timestamp when the shared preference was created. Defaults to the current time.';

-- Updated At: Timestamp of when the preference was last updated.
COMMENT ON COLUMN public.shared_preferences.updated_at IS 'Timestamp when the shared preference was last updated. Defaults to the current time.';

-- All Closet: Boolean indicating whether these preferences apply to all closets.
COMMENT ON COLUMN public.shared_preferences.all_closet IS 'Boolean flag indicating whether the preferences filters to all closets (TRUE) or just a specific one (FALSE).';

-- Grid: Defines the number of items displayed per row.
COMMENT ON COLUMN public.shared_preferences.grid IS 'Integer defining the grid layout (number of items per row) between 2 and 7. Defaults to 3.';

-- Sort: The criteria by which the closets are sorted.
COMMENT ON COLUMN public.shared_preferences.sort IS 'Defines the sorting criteria for closets, such as updated_at, created_at, amount_spent, item_last_worn, etc. Defaults to updated_at.';

-- Order: Sorting order, either ascending or descending.
COMMENT ON COLUMN public.shared_preferences.order IS 'Defines the sorting order, either asc (ascending) or desc (descending). Defaults to desc.';


ALTER TABLE public.user_closets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shared_preferences ENABLE ROW LEVEL SECURITY;


CREATE POLICY "Allow user to select own_closets"
ON public.user_closets
FOR SELECT
to authenticated
using (
  (( SELECT auth.uid() AS uid) = user_id)
);


CREATE POLICY "Allow user to insert own_closets"
ON public.user_closets
FOR INSERT
to authenticated
with check (
  (( SELECT auth.uid() AS uid) = user_id)
  );

CREATE POLICY "Allow user to update own_closets"
ON public.user_closets
FOR UPDATE
TO authenticated
USING (
  (SELECT auth.uid() AS uid) = user_id
)
WITH CHECK (
  (SELECT auth.uid() AS uid) = user_id
);

CREATE POLICY "Allow user to delete own_closets"
ON public.user_closets
FOR DELETE
to authenticated
using (
  (( SELECT auth.uid() AS uid) = user_id)
);


CREATE POLICY "Allow user to select own_preferences"
ON public.shared_preferences
FOR SELECT
to authenticated
using (
  (( SELECT auth.uid() AS uid) = user_id)
);

CREATE POLICY "Allow user to insert own_preferences"
ON public.shared_preferences
FOR INSERT
to authenticated
with check (
  (( SELECT auth.uid() AS uid) = user_id)
  );

CREATE POLICY "Allow user to update own_preferences"
ON public.shared_preferences
FOR UPDATE
TO authenticated
USING (
  (SELECT auth.uid() AS uid) = user_id
)
WITH CHECK (
  (SELECT auth.uid() AS uid) = user_id
);

CREATE POLICY  "Allow user to delete own_preferences"
ON public.shared_preferences
FOR DELETE
to authenticated
using (
  (( SELECT auth.uid() AS uid) = user_id)
);
