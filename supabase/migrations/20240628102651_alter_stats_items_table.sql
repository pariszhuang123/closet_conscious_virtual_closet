-- Altering user_low_freq_stats table
ALTER TABLE user_low_freq_stats
ADD COLUMN multi_closet_request int4 DEFAULT 0 NOT NULL,
ADD COLUMN filter_request int4 DEFAULT 0 NOT NULL,
ADD COLUMN analytics_request int4 DEFAULT 0 NOT NULL,

-- Adding comments to user_low_freq_stats table columns
COMMENT ON COLUMN user_low_freq_stats.multi_closet_request IS 'Tracks the number of times multiple closets feature are requested';
COMMENT ON COLUMN user_low_freq_stats.filter_request IS 'Tracks the number of times filters feature are requested';
COMMENT ON COLUMN user_low_freq_stats.analytics_request IS 'Tracks the number of times analytics features are requested';

-- Altering items table
ALTER TABLE items
ADD COLUMN item_last_worn DATE DEFAULT '2024-03-11' NOT NULL,
ADD COLUMN worn_in_outfit INT4 DEFAULT 0 NOT NULL;

-- Adding comments to items table columns
COMMENT ON COLUMN items.item_last_worn IS 'Records the date when the item was last worn, if its on 11 March 2024 (CC was born), it has not being worn before';
COMMENT ON COLUMN items.worn_in_outfit IS 'Counts the number of times the item has been worn in an outfit';