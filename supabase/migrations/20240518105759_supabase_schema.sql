-- Create a table for users
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT CHECK (role IN ('user', 'admin', 'developer')) DEFAULT 'user',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create a table for items
CREATE TABLE items (
    item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    item_type TEXT CHECK (item_type IN ('clothing', 'accessory', 'shoes')) NOT NULL,
    sub_status TEXT CHECK (sub_status IN ('own', 'rent', 'lent', 'store', 'sold', 'damage', 'tailored', 'throw_away', 'gift')) DEFAULT 'own',
    image_url TEXT, -- Column to store the image URL or file path
    status TEXT CHECK (status IN ('active', 'inactive')) DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT chk_updated CHECK (updated_at >= created_at) -- Ensure updated_at is never before created_at
);

CREATE INDEX idx_items_user_id ON items (user_id);

-- Outfits Table
CREATE TABLE outfits (
    outfit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    creation_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    feedback TEXT CHECK (feedback IN ('like', 'alright', 'dislike')) DEFAULT 'like',
    reviewed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_outfits_user_id ON outfits (user_id);

-- Outfit Items Join Table
CREATE TABLE outfit_items (
    outfit_id UUID REFERENCES outfits(outfit_id),
    item_id UUID REFERENCES items(item_id),
    user_id UUID REFERENCES users(user_id),
    PRIMARY KEY (outfit_id, item_id),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_outfit_items_item_id ON outfit_items (item_id);
CREATE INDEX idx_outfit_items_outfit_id ON outfit_items (outfit_id);

-- Disliked Items in Outfits Join Table
CREATE TABLE disliked_outfit_items (
    outfit_id UUID REFERENCES outfits(outfit_id),
    item_id UUID REFERENCES items(item_id),
    user_id UUID REFERENCES users(user_id),
    PRIMARY KEY (outfit_id, item_id),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Swaps Table
CREATE TABLE swaps (
    swap_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID REFERENCES items(item_id),
    owner_id UUID NOT NULL REFERENCES users(user_id),
    new_owner_id UUID NOT NULL REFERENCES users(user_id),
    swap_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status TEXT CHECK (status IN ('pending', 'completed', 'initiated', 'cancelled')) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
);

-- Premium Services Table
CREATE TABLE premium_services (
    premium_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    service_type TEXT CHECK (service_type IN ('usage_based', 'feature_activation')) NOT NULL,
    sub_service TEXT NOT NULL,
    activation_date TIMESTAMPTZ,
    status TEXT CHECK (status IN ('active', 'inactive')) DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
);

-- Challenges Table
CREATE TABLE challenges (
    challenge_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    challenge_type TEXT NOT NULL,
    start_date TIMESTAMPTZ NOT NULL,
    actual_end_date TIMESTAMPTZ,
    challenge_status TEXT CHECK (challenge_status IN ('active', 'failed', 'completed')) DEFAULT 'active',
    challenge_status_date TIMESTAMPTZ,
    affected_premium_feature UUID REFERENCES premium_services(premium_id),
    reattempt_date TIMESTAMPTZ,
    can_reattempt BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- User Goals Table
CREATE TABLE user_goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    goal_type TEXT CHECK (goal_type IN ('upload_item', 'create_outfit', 'days_no_shopping')),
    current_streak INTEGER DEFAULT 0,
    highest_streak INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
);

-- High-Frequency User Stats Table
CREATE TABLE user_high_freq_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    items_uploaded INTEGER DEFAULT 0,
    items_edited INTEGER DEFAULT 0,
    outfits_created INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Low-Frequency User Stats Table
CREATE TABLE user_low_freq_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    items_swapped INTEGER DEFAULT 0,
    items_sold INTEGER DEFAULT 0,
    items_gifted INTEGER DEFAULT 0,
    new_clothings INTEGER DEFAULT 0,
    new_clothings_value INTEGER DEFAULT 0,
    app_ambassador INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
