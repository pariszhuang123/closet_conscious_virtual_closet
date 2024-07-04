ALTER TABLE public.outfits
DROP COLUMN creation_date;

ALTER TABLE public.user_high_freq_stats
ADD COLUMN no_buy_streak INTEGER DEFAULT 0 NOT NULL,
ADD COLUMN no_buy_highest_streak INTEGER DEFAULT 0 NOT NULL,
ADD COLUMN daily_upload BOOLEAN DEFAULT FALSE NOT NULL;

ALTER TABLE public.user_low_freq_stats
DROP COLUMN app_ambassador;
