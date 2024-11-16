import { serve } from 'https://deno.land/std@0.180.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js';
import { verify } from "https://deno.land/x/djwt@v2.8/mod.ts";

// Initialize Supabase client
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

// Initialize JWT Secret
const SUPABASE_JWT_SECRET = Deno.env.get('JWT_SECRET')!;
if (!SUPABASE_JWT_SECRET) {
  throw new Error('Supabase JWT secret is not set in environment variables');
}

serve(async (req) => {
  try {
    console.log('Received iOS purchase verification request');

    // Extract User JWT from Authorization header
    const authHeader = req.headers.get('Authorization');
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.error('Missing or invalid Authorization header');
      return new Response(
        JSON.stringify({ error: 'Missing or invalid Authorization header' }),
        { status: 401 },
      );
    }

    const userJwt = authHeader.split(' ')[1];
    let userId: string;

    try {
      // Verify JWT and extract user_id
      const keyBuf = new TextEncoder().encode(SUPABASE_JWT_SECRET);
      const key = await crypto.subtle.importKey(
        "raw",
        keyBuf,
        { name: "HMAC", hash: "SHA-256" },
        false,
        ["verify"],
      );

      const payload = await verify(userJwt, key);
      userId = payload.sub as string;

      if (!userId) {
        throw new Error('User ID (sub) not found in token');
      }

      console.log('Authenticated user ID:', userId);
    } catch (err) {
      console.error('Invalid JWT:', err);
      return new Response(
        JSON.stringify({ error: 'Invalid authentication token' }),
        { status: 401 },
      );
    }

    // Parse the request body to get the iOS receipt data
    const { receiptData, productId } = await req.json();
    console.log('Request payload:', { receiptData, productId });

    // Determine if using sandbox or production Apple endpoint
    const appleVerifyUrl = Deno.env.get('ENV') === 'production'
      ? 'https://buy.itunes.apple.com/verifyReceipt'
      : 'https://sandbox.itunes.apple.com/verifyReceipt';

    // Prepare the request payload with receipt data and shared secret
    const body = JSON.stringify({
      'receipt-data': receiptData,
    });

    // Send receipt to Apple for verification
    const response = await fetch(appleVerifyUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: body,
    });

    if (response.ok) {
      const data = await response.json();
      console.log('Apple receipt verification response:', data);

      if (data.status === 0) { // Status 0 indicates a valid receipt
        const inAppPurchases = data.receipt.in_app;

        // Filter and sort the purchases for the given productId
        const recentPurchase = inAppPurchases
          .filter((purchase: any) => purchase.product_id === productId)
          .sort((a: any, b: any) => parseInt(b.purchase_date_ms) - parseInt(a.purchase_date_ms))[0];

        if (!recentPurchase) {
          console.error(`No purchases found for product ID: ${productId}`);
          return new Response(
            JSON.stringify({ error: 'No purchases found for the specified product ID' }),
            { status: 404 },
          );
        }

        const transactionId = recentPurchase.transaction_id;
        const purchaseDate = parseInt(recentPurchase.purchase_date_ms);
        const countryCode = 'cc_none'; // Default or retrieve if applicable

        // Persist the purchase in Supabase using an RPC function
        const rpcResponse = await triggerPersistPurchaseRPC(
          userId,
          transactionId,
          productId,
          purchaseDate,
          countryCode
        );

        console.log('RPC Response:', rpcResponse);
        return new Response(
          JSON.stringify({ status: 'success', message: 'iOS Purchase recorded successfully' }),
          { status: 200, headers: { "Content-Type": "application/json" } }
        );
      } else {
        console.error('Invalid Apple receipt status:', data.status);
        return new Response(
          JSON.stringify({ error: 'Invalid receipt status', status: data.status }),
          { status: 400 }
        );
      }
    } else {
      const errorData = await response.json();
      console.error('Error in iOS purchase verification:', errorData);
      return new Response(
        JSON.stringify({ success: false, error: errorData }),
        { status: response.status, headers: { "Content-Type": "application/json" } }
      );
    }
  } catch (error) {
    console.error('Error during function execution:', error);
    return new Response(
      JSON.stringify({ success: false, error: error.message || 'Internal server error' }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});

// Helper function to trigger the persist purchase RPC
async function triggerPersistPurchaseRPC(
  userId: string,
  transactionId: string,
  productId: string,
  purchaseDate: number,
  countryCode: string,
): Promise<any> {
  const { data, error } = await supabase.rpc('ios_persist_purchase', {
    p_user_id: userId,
    p_transaction_id: transactionId,
    p_product_id: productId,
    p_purchase_date: purchaseDate,
    p_country_code: countryCode,
  });

  if (error) {
    console.error('Error calling RPC:', error);
    return { status: 'error', message: error.message };
  }

  console.log('RPC call successful, response:', data);
  return {
    status: 'success',
    message: 'Purchase recorded successfully',
    data: data,
  };
}
