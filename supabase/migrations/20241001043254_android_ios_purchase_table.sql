CREATE TABLE public.purchases (
  transaction_id TEXT primary key NOT NULL,
  user_id UUID NOT NULL references user_profiles(id) on delete cascade,
  product_id TEXT NOT NULL,
  purchase_date TIMESTAMPTZ NOT NULL,
  purchase_token TEXT NOT NULL DEFAULT 'cc_none',
  country_code TEXT NOT NULL
);


COMMENT ON TABLE public.purchases IS 'Table storing in-app purchase records for both Android and iOS platforms. Tracks transaction details and user-specific purchase data.';

COMMENT ON COLUMN public.purchases.transaction_id IS 'The unique transaction identifier (iOS: transaction_id, Android: orderId). These identifiers are unique per platform, but Android uses a longer string format compared to iOS.';
COMMENT ON COLUMN public.purchases.user_id IS 'The ID of the user making the purchase, linked to the auth.uid() in Supabase.';
COMMENT ON COLUMN public.purchases.product_id IS 'The product identifier for the in-app purchase (same for both iOS and Android).';
COMMENT ON COLUMN public.purchases.purchase_date IS 'The timestamp indicating when the purchase was made. On Android, this is retrieved from the Google Play API, while on iOS, it comes from the App Store API. The formats of the date are standardized across both platforms.';
COMMENT ON COLUMN public.purchases.purchase_token IS 'The purchase token for Android (Google Play Store), used to verify purchase details. For iOS (App Store), this field defaults to "cc_none".';
COMMENT ON COLUMN public.purchases.country_code IS 'The ISO 3166-1 alpha-2 country code based on the device locale or app store region. Both Android and iOS follow this standard, but note that special values may be used for regions like "Rest of World".';

ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow users to access their own purchases"
  ON public.purchases
FOR SELECT
TO authenticated
USING (
    user_id = (SELECT auth.uid())
);

CREATE POLICY "Allow user to insert their own purchases"
ON public.purchases
FOR INSERT
TO authenticated
WITH CHECK (
    user_id = (SELECT auth.uid())
);

CREATE POLICY "Allow user to update their own purchases"
ON public.purchases
FOR UPDATE
TO authenticated
USING (
    user_id = (SELECT auth.uid())
)
WITH CHECK (
    user_id = (SELECT auth.uid())
);



CREATE POLICY "Allow user to delete their own purchases"
ON public.purchases
FOR DELETE
TO authenticated
USING (
    user_id = (SELECT auth.uid())
);