ALTER TABLE public.user_low_freq_stats
ADD COLUMN selfie int4 DEFAULT 0 NOT NULL,
ADD COLUMN calendar_request int4 DEFAULT 0 NOT NULL;

ALTER TABLE public.outfits
ADD COLUMN outfits_image_url text;

COMMENT ON COLUMN public.items.price_per_wear IS 'This shows how cost-effective an item is by considering how often it is worn against its price';
COMMENT ON COLUMN public.user_low_freq_stats.selfie IS 'Stores selfies count. Defaults to 0 if no selfies are recorded.';
COMMENT ON COLUMN public.user_low_freq_stats.calendar_request IS 'Stores calendar requests count. Defaults to 0 if no requests are made.';
COMMENT ON COLUMN public.outfits.outfits_image_url IS 'Holds URL of the image associated with the outfit.';
