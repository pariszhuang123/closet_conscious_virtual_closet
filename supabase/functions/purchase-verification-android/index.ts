import { serve } from 'https://deno.land/std@0.180.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js';
import { verify } from "https://deno.land/x/djwt@v2.8/mod.ts";
import { decode as base64Decode } from "https://deno.land/std@0.180.0/encoding/base64.ts";

// Initialize Supabase client
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

// Initialize JWT Secret
const SUPABASE_JWT_SECRET = Deno.env.get('JWT_SECRET')!;
if (!SUPABASE_JWT_SECRET) {
  throw new Error('Supabase JWT secret is not set in environment variables');
}

// Cached access token and expiration time
let cachedAccessToken: string | null = null;
let tokenExpirationTime: number | null = null;

serve(async (req) => {
  try {
    console.log('Received request');

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
      // Convert the secret into a CryptoKey
      const keyBuf = new TextEncoder().encode(SUPABASE_JWT_SECRET);
      const key = await crypto.subtle.importKey(
        "raw",
        keyBuf,
        { name: "HMAC", hash: "SHA-256" },
        false,
        ["verify"],
      );

      // Verify the JWT using the CryptoKey
      const payload = await verify(userJwt, key);

      // Extract user_id from the 'sub' claim
      userId = payload.sub as string;

      if (!userId) {
        throw new Error('User ID (sub) not found in token');
      }

      console.log('Authenticated user ID');
    } catch (err) {
      console.error('Invalid JWT:', err);
      return new Response(
        JSON.stringify({ error: 'Invalid authentication token' }),
        { status: 401 },
      );
    }

    // Parse the request body
    const { purchaseToken, productId } = await req.json();
    console.log('Request payload:', { purchaseToken, productId });

    // Fetch access token using the service account credentials
    const accessToken = await getAccessToken();
    console.log('Fetched access token');

    // Package name of the Android app
    const packageName = 'com.makinglifeeasie.closetconscious';

    // Verify purchase using Google's API
    console.log('Verifying purchase...');
    const response = await fetch(
      `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/products/${productId}/tokens/${purchaseToken}`,
      {
        headers: {
          'Authorization': `Bearer ${accessToken}`, // Use the service account access token
          'Accept': 'application/json',
        },
      }
    );

    if (response.ok) {
      const data = await response.json();
      console.log('Purchase verification successful:', data);

      const transactionId = data.orderId;
      const purchaseDate = data.purchaseTimeMillis;
      const countryCode = data.regionCode || 'cc_none'; // Fallback if regionCode is missing
      const purchaseState = data.purchaseState;

      // Handle different purchase states
      if (purchaseState === 0) { // Purchase is complete
        console.log('Purchase complete, acknowledging purchase...');
        await acknowledgePurchase(packageName, productId, purchaseToken, accessToken);

        // Trigger the Supabase RPC for persisting purchase data
        console.log('Persisting purchase in Supabase...');
        const rpcResponse = await triggerPersistPurchaseRPC(
          userId, // Securely obtained userId
          transactionId,
          productId,
          purchaseToken,
          purchaseDate,
          countryCode
        );

        console.log('RPC Response:', rpcResponse);
        return new Response(
          JSON.stringify({
            success: true,
            data: rpcResponse,
          }),
          { status: 200, headers: { "Content-Type": "application/json" } }
        );
      } else if (purchaseState === 1) { // Purchase is pending
        console.warn('Purchase is pending');
        return new Response(
          JSON.stringify({
            success: false,
            error: 'Purchase is pending',
          }),
          { status: 202, headers: { "Content-Type": "application/json" } }
        );
      } else if (purchaseState === 2) { // Purchase is canceled
        console.warn('Purchase is canceled');
        return new Response(
          JSON.stringify({
            success: false,
            error: 'Purchase is canceled',
          }),
          { status: 400, headers: { "Content-Type": "application/json" } }
        );
      } else {
        console.error('Invalid purchase state:', purchaseState);
        return new Response(
          JSON.stringify({
            success: false,
            error: `Invalid purchase state: ${purchaseState}`,
          }),
          { status: 400, headers: { "Content-Type": "application/json" } }
        );
      }
    } else {
      const errorData = await response.json();
      console.error('Error in purchase verification:', errorData);
      return new Response(
        JSON.stringify({
          success: false,
          error: errorData,
        }),
        { status: response.status, headers: { "Content-Type": "application/json" } }
      );
    }
  } catch (error) {
    console.error('Error during function execution:', error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || 'Internal server error',
      }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});

// Helper function to get access token with caching
async function getAccessToken(): Promise<string> {
  const currentTime = Math.floor(Date.now() / 1000);

  // If token is cached and not expired, return the cached token
  if (cachedAccessToken && tokenExpirationTime && currentTime < tokenExpirationTime) {
    console.log('Using cached access token');
    return cachedAccessToken;
  }

  const serviceAccountKeyBase64 = Deno.env.get('SERVICE_ACCOUNT_KEY_BASE64');
  if (!serviceAccountKeyBase64) {
    throw new Error('Service account key not set in environment variables');
  }

  console.log('Generating new access token...');

  // Decode the base64-encoded service account key
  let decodedServiceAccountKey: string;
  try {
    const decodedBytes = base64Decode(serviceAccountKeyBase64);
    decodedServiceAccountKey = new TextDecoder().decode(decodedBytes);
  } catch (error) {
    console.error('Failed to decode service account key:', error);
    throw new Error('Invalid service account key encoding');
  }

  const serviceAccountCredentials = JSON.parse(decodedServiceAccountKey);

  const now = Math.floor(Date.now() / 1000);
  const jwtHeader = {
    alg: 'RS256',
    typ: 'JWT',
  };

  const jwtClaimSet = {
    iss: serviceAccountCredentials.client_email,
    scope: 'https://www.googleapis.com/auth/androidpublisher',
    aud: 'https://oauth2.googleapis.com/token',
    exp: now + 3600,
    iat: now,
  };

  const encoder = new TextEncoder();
  const encodedHeader = base64urlEncode(encoder.encode(JSON.stringify(jwtHeader)));
  const encodedClaimSet = base64urlEncode(encoder.encode(JSON.stringify(jwtClaimSet)));

  const unsignedJwt = `${encodedHeader}.${encodedClaimSet}`;

  // Import the private key
  const privateKey = serviceAccountCredentials.private_key;
  const keyData = await crypto.subtle.importKey(
    'pkcs8',
    pemToArrayBuffer(privateKey),
    {
      name: 'RSASSA-PKCS1-v1_5',
      hash: 'SHA-256',
    },
    false,
    ['sign']
  );

  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    keyData,
    encoder.encode(unsignedJwt)
  );

  const encodedSignature = base64urlEncode(new Uint8Array(signature));

  const signedJwt = `${unsignedJwt}.${encodedSignature}`;

  const tokenResponse = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    body: JSON.stringify({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: signedJwt,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  });

  if (!tokenResponse.ok) {
    throw new Error(`Failed to get access token: ${tokenResponse.statusText}`);
  }

  const tokenData = await tokenResponse.json();

  // Cache the access token and its expiration time
  cachedAccessToken = tokenData.access_token;
  tokenExpirationTime = now + 3600; // Tokens are valid for 1 hour
  console.log('Access token generated and cached');

  return cachedAccessToken;
}

// Helper function to acknowledge the purchase
async function acknowledgePurchase(
  packageName: string,
  productId: string,
  purchaseToken: string,
  accessToken: string,
) {
  const acknowledgeUrl = `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/products/${productId}/tokens/${purchaseToken}:acknowledge`;

  const acknowledgeResponse = await fetch(acknowledgeUrl, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${accessToken}`, // Use the service account access token
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({}),
  });

  if (!acknowledgeResponse.ok) {
    const errorData = await acknowledgeResponse.json();
    console.error('Failed to acknowledge purchase:', errorData);
    throw new Error('Purchase acknowledgment failed');
  }
}

// Helper function to trigger the persist purchase RPC
async function triggerPersistPurchaseRPC(
  userId: string, // Securely obtained userId
  transactionId: string,
  productId: string,
  purchaseToken: string,
  purchaseDate: number,
  countryCode: string,
): Promise<any> {
  const { data, error } = await supabase.rpc('android_persist_purchase', {
    p_user_id: userId, // Pass user_id as a parameter
    p_transaction_id: transactionId,
    p_product_id: productId,
    p_purchase_token: purchaseToken,
    p_purchase_date: purchaseDate,
    p_country_code: countryCode,
  });

  if (error) {
    console.error('Error calling RPC:', error);
    return { status: 'error', message: error.message };
  }

  return data;
}

// Helper function for base64url encoding
function base64urlEncode(arraybuffer: ArrayBuffer): string {
  let base64 = btoa(String.fromCharCode(...new Uint8Array(arraybuffer)));
  return base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

// Helper function to convert PEM to ArrayBuffer
function pemToArrayBuffer(pem: string): ArrayBuffer {
  const b64 = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\s+/g, '');
  const binaryDerString = atob(b64);
  const binaryDer = new Uint8Array(binaryDerString.length);
  for (let i = 0; i < binaryDerString.length; i++) {
    binaryDer[i] = binaryDerString.charCodeAt(i);
  }
  return binaryDer.buffer;
}
