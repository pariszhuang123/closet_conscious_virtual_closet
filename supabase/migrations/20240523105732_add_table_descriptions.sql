-- Add descriptions to tables and columns

-- Users Table
COMMENT ON TABLE users IS 'This table stores the basic information of users in the application.';
COMMENT ON COLUMN users.user_id IS 'Primary key, unique identifier for each user, generated automatically.';
COMMENT ON COLUMN users.name IS 'The name of the user, cannot be null.';
COMMENT ON COLUMN users.email IS 'The email address of the user, must be unique and cannot be null.';
COMMENT ON COLUMN users.role IS 'The role of the user, must be one of ''user'', ''admin'', or ''developer'', default is ''user''.';
COMMENT ON COLUMN users.created_at IS 'Timestamp when the user was created, default is the current time.';
COMMENT ON COLUMN users.updated_at IS 'Timestamp when the user was last updated, default is the current time.';

-- Items Table
COMMENT ON TABLE items IS 'This table stores information about the clothing items of users.';
COMMENT ON COLUMN items.item_id IS 'Primary key, unique identifier for each item, generated automatically.';
COMMENT ON COLUMN items.user_id IS 'Foreign key referencing users(user_id), indicating the owner of the item.';
COMMENT ON COLUMN items.item_type IS 'The type of the item, must be one of ''clothing'', ''accessory'', or ''shoes''.';
COMMENT ON COLUMN items.sub_status IS 'The status of the item, default is ''own'', must be one of several specified statuses like ''rent'', ''sold'', etc.';
COMMENT ON COLUMN items.image_url IS 'URL or file path to the image of the item.';
COMMENT ON COLUMN items.status IS 'The status of the item, default is ''active'', must be ''active'' or ''inactive''.';
COMMENT ON COLUMN items.created_at IS 'Timestamp when the item was created, default is the current time.';
COMMENT ON COLUMN items.updated_at IS 'Timestamp when the item was last updated, default is the current time. Ensure updated_at is never before created_at (constraint chk_updated).';

-- Outfits Table
COMMENT ON TABLE outfits IS 'This table stores information about outfits created by users.';
COMMENT ON COLUMN outfits.outfit_id IS 'Primary key, unique identifier for each outfit, generated automatically.';
COMMENT ON COLUMN outfits.user_id IS 'Foreign key referencing users(user_id), indicating the creator of the outfit.';
COMMENT ON COLUMN outfits.creation_date IS 'Timestamp when the outfit was created, default is the current time.';
COMMENT ON COLUMN outfits.feedback IS 'User''s feedback on the outfit, default is ''like'', must be ''like'', ''alright'', or ''dislike''.';
COMMENT ON COLUMN outfits.reviewed IS 'Indicates if the outfit has been reviewed, default is FALSE.';
COMMENT ON COLUMN outfits.created_at IS 'Timestamp when the outfit record was created, default is the current time.';
COMMENT ON COLUMN outfits.updated_at IS 'Timestamp when the outfit record was last updated, default is the current time.';

-- Outfit Items Join Table
COMMENT ON TABLE outfit_items IS 'This table establishes a many-to-many relationship between outfits and items.';
COMMENT ON COLUMN outfit_items.outfit_id IS 'Foreign key referencing outfits(outfit_id).';
COMMENT ON COLUMN outfit_items.item_id IS 'Foreign key referencing items(item_id).';
COMMENT ON COLUMN outfit_items.user_id IS 'Foreign key referencing users(user_id).';
COMMENT ON COLUMN outfit_items.created_at IS 'Timestamp when the record was created, default is the current time.';
COMMENT ON COLUMN outfit_items.updated_at IS 'Timestamp when the record was last updated, default is the current time.';

-- Disliked Items in Outfits Join Table
COMMENT ON TABLE disliked_outfit_items IS 'This table records items that users disliked in their outfits.';
COMMENT ON COLUMN disliked_outfit_items.outfit_id IS 'Foreign key referencing outfits(outfit_id).';
COMMENT ON COLUMN disliked_outfit_items.item_id IS 'Foreign key referencing items(item_id).';
COMMENT ON COLUMN disliked_outfit_items.user_id IS 'Foreign key referencing users(user_id).';
COMMENT ON COLUMN disliked_outfit_items.created_at IS 'Timestamp when the record was created, default is the current time.';
COMMENT ON COLUMN disliked_outfit_items.updated_at IS 'Timestamp when the record was last updated, default is the current time.';

-- Swaps Table
COMMENT ON TABLE swaps IS 'This table stores information about item swaps between users.';
COMMENT ON COLUMN swaps.swap_id IS 'Primary key, unique identifier for each swap, generated automatically.';
COMMENT ON COLUMN swaps.item_id IS 'Foreign key referencing items(item_id), indicating the item being swapped.';
COMMENT ON COLUMN swaps.owner_id IS 'Foreign key referencing users(user_id), indicating the current owner of the item.';
COMMENT ON COLUMN swaps.new_owner_id IS 'Foreign key referencing users(user_id), indicating the new owner of the item.';
COMMENT ON COLUMN swaps.swap_date IS 'Timestamp when the swap occurred, default is the current time.';
COMMENT ON COLUMN swaps.status IS 'The status of the swap, default is ''pending'', must be ''pending'', ''completed'', ''initiated'', or ''cancelled''.';
COMMENT ON COLUMN swaps.created_at IS 'Timestamp when the swap record was created, default is the current time.';
COMMENT ON COLUMN swaps.updated_at IS 'Timestamp when the swap record was last updated, default is the current time.';

-- Premium Services Table
COMMENT ON TABLE premium_services IS 'This table stores information about premium services activated by users.';
COMMENT ON COLUMN premium_services.premium_id IS 'Primary key, unique identifier for each premium service, generated automatically.';
COMMENT ON COLUMN premium_services.user_id IS 'Foreign key referencing users(user_id), indicating the user who activated the service.';
COMMENT ON COLUMN premium_services.service_type IS 'The type of the premium service, must be ''usage_based'' or ''feature_activation''.';
COMMENT ON COLUMN premium_services.sub_service IS 'The specific sub-service activated by the user.';
COMMENT ON COLUMN premium_services.activation_date IS 'Timestamp when the service was activated.';
COMMENT ON COLUMN premium_services.status IS 'The status of the service, default is ''active'', must be ''active'' or ''inactive''.';
COMMENT ON COLUMN premium_services.created_at IS 'Timestamp when the premium service record was created, default is the current time.';
COMMENT ON COLUMN premium_services.updated_at IS 'Timestamp when the premium service record was last updated, default is the current time.';

-- Challenges Table
COMMENT ON TABLE challenges IS 'This table stores information about challenges undertaken by users.';
COMMENT ON COLUMN challenges.challenge_id IS 'Primary key, unique identifier for each challenge, generated automatically.';
COMMENT ON COLUMN challenges.user_id IS 'Foreign key referencing users(user_id), indicating the user who started the challenge.';
COMMENT ON COLUMN challenges.challenge_type IS 'The type of challenge.';
COMMENT ON COLUMN challenges.start_date IS 'Timestamp when the challenge started.';
COMMENT ON COLUMN challenges.actual_end_date IS 'Timestamp when the challenge ended.';
COMMENT ON COLUMN challenges.challenge_status IS 'The status of the challenge, default is ''active'', must be ''active'', ''failed'', or ''completed''.';
COMMENT ON COLUMN challenges.challenge_status_date IS 'Timestamp when the challenge status was last updated.';
COMMENT ON COLUMN challenges.affected_premium_feature IS 'Foreign key referencing premium_services(premium_id), indicating a related premium feature.';
COMMENT ON COLUMN challenges.reattempt_date IS 'Timestamp when the challenge can be reattempted.';
COMMENT ON COLUMN challenges.can_reattempt IS 'Indicates if the challenge can be reattempted, default is TRUE.';
COMMENT ON COLUMN challenges.created_at IS 'Timestamp when the challenge record was created, default is the current time.';
COMMENT ON COLUMN challenges.updated_at IS 'Timestamp when the challenge record was last updated, default is the current time.';

-- User Goals Table
COMMENT ON TABLE user_goals IS 'This table stores user-specific goals and their progress.';
COMMENT ON COLUMN user_goals.id IS 'Primary key, unique identifier for each goal, generated automatically.';
COMMENT ON COLUMN user_goals.user_id IS 'Foreign key referencing users(user_id), indicating the user who set the goal.';
COMMENT ON COLUMN user_goals.goal_type IS 'The type of goal, must be ''upload_item'', ''create_outfit'', or ''days_no_shopping''.';
COMMENT ON COLUMN user_goals.current_streak IS 'The current streak of goal completion.';
COMMENT ON COLUMN user_goals.highest_streak IS 'The highest streak of goal completion.';
COMMENT ON COLUMN user_goals.created_at IS 'Timestamp when the goal record was created, default is the current time.';
COMMENT ON COLUMN user_goals.updated_at IS 'Timestamp when the goal record was last updated, default is the current time.';

-- High-Frequency User Stats Table
COMMENT ON TABLE user_high_freq_stats IS 'This table stores statistics for high-frequency user actions.';
COMMENT ON COLUMN user_high_freq_stats.id IS 'Primary key, unique identifier for each record, generated automatically.';
COMMENT ON COLUMN user_high_freq_stats.user_id IS 'Foreign key referencing users(user_id), indicating the user associated with the stats.';
COMMENT ON COLUMN user_high_freq_stats.items_uploaded IS 'The number of items uploaded by the user.';
COMMENT ON COLUMN user_high_freq_stats.items_edited IS 'The number of items edited by the user.';
COMMENT ON COLUMN user_high_freq_stats.outfits_created IS 'The number of outfits created by the user.';
COMMENT ON COLUMN user_high_freq_stats.created_at IS 'Timestamp when the stats record was created, default is the current time.';
COMMENT ON COLUMN user_high_freq_stats.updated_at IS 'Timestamp when the stats record was last updated, default is the current time.';

-- Low-Frequency User Stats Table
COMMENT ON TABLE user_low_freq_stats IS 'This table stores statistics for low-frequency user actions.';
COMMENT ON COLUMN user_low_freq_stats.id IS 'Primary key, unique identifier for each record, generated automatically.';
COMMENT ON COLUMN user_low_freq_stats.user_id IS 'Foreign key referencing users(user_id), indicating the user associated with the stats.';
COMMENT ON COLUMN user_low_freq_stats.items_swapped IS 'The number of items swapped by the user.';
COMMENT ON COLUMN user_low_freq_stats.items_sold IS 'The number of items sold by the user.';
COMMENT ON COLUMN user_low_freq_stats.items_gifted IS 'The number of items gifted by the user.';
COMMENT ON COLUMN user_low_freq_stats.new_clothings IS 'The number of new clothing items acquired by the user.';
COMMENT ON COLUMN user_low_freq_stats.new_clothings_value IS 'The value of new clothing items acquired by the user.';
COMMENT ON COLUMN user_low_freq_stats.app_ambassador IS 'Indicates the user''s ambassador status in the app.';
COMMENT ON COLUMN user_low_freq_stats.created_at IS 'Timestamp when the stats record was created, default is the current time.';
COMMENT ON COLUMN user_low_freq_stats.updated_at IS 'Timestamp when the stats record was last updated, default is the current time.';
