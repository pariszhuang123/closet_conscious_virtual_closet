CREATE OR REPLACE FUNCTION public.android_persist_purchase(
    p_product_id text,
    p_purchase_token text,
    p_transaction_id text,
    p_purchase_date bigint,
    p_country_code text
)
RETURNS json
SET search_path = 'public'
LANGUAGE plpgsql
AS $$
DECLARE
    current_user_id uuid := auth.uid();
    acquisition_method text := 'paid';  -- Default acquisition method

BEGIN
    -- Validate input parameters
    IF p_product_id IS NULL OR p_purchase_token IS NULL OR p_transaction_id IS NULL THEN
        RETURN json_build_object('status', 'error', 'message', 'Invalid input parameters');
    END IF;

    -- Insert the purchase data into the purchases table
    BEGIN
        INSERT INTO public.purchases (
            user_id,
            product_id,
            purchase_token,
            transaction_id,
            purchase_date,
            country_code
        ) VALUES (
            current_user_id,
            p_product_id,
            p_purchase_token,
            p_transaction_id,
            to_timestamp(p_purchase_date / 1000), -- Convert milliseconds to timestamp
            p_country_code
        );

        -- Update the premium_services table
        UPDATE public.premium_services
            SET
                one_off_features = jsonb_set(
                    one_off_features,
                    ARRAY[p_product_id],
                    jsonb_build_object('acquisition_method', acquisition_method, 'acquisition_date', CURRENT_TIMESTAMP)
                ),
                updated_at = NOW()
            WHERE user_id = current_user_id;

        RETURN json_build_object('status', 'success', 'message', 'Purchase recorded successfully');
    EXCEPTION
        WHEN OTHERS THEN
            RETURN json_build_object('status', 'error', 'message', SQLERRM);
    END;
END;
$$;
