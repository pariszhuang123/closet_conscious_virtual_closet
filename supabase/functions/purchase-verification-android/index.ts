// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
/// <reference types="https://esm.sh/@supabase/functions-js/src/edge-runtime.d.ts" />

import { serve } from 'https://deno.land/std@0.131.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js';

serve(async (req) => {
  try {
    // Ensure the request has an Authorization header
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), { status: 401 });
    }
    const { purchaseToken, productId } = await req.json();

    // Fetch access token using the service account credentials
    const accessToken = await getAccessToken();

    // Package name of the Android app
    const packageName = 'com.makinglifeeasie.closetconscious';

    // Verify purchase using Google's API
    const response = await fetch(
      `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/products/${productId}/tokens/${purchaseToken}`,
      {
        headers: {
          'Authorization': `Bearer ${accessToken}`,
          'Accept': 'application/json',
        },
      }
    );

    if (response.ok) {
      const data = await response.json();

      // Extract necessary fields
      const transactionId = data.orderId;
      const purchaseDate = data.purchaseTimeMillis;
      const countryCode = data.regionCode;
      const isValid = data.purchaseState === 0;

      // Proceed if the purchase is valid
      if (isValid) {
        // Trigger the Supabase RPC for persisting purchase data
        const rpcResponse = await triggerPersistPurchaseRPC(
          transactionId,
          productId,
          purchaseToken,
          purchaseDate,
          countryCode
        );

        return new Response(JSON.stringify(rpcResponse), { status: 200 });
      } else {
        return new Response(JSON.stringify({ error: 'Invalid purchase state' }), { status: 400 });
      }
    } else {
      const errorData = await response.json();
      return new Response(JSON.stringify({ error: errorData }), { status: response.status });
    }
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }
});


// Helper function to get access token
async function getAccessToken(): Promise<string> {
  const serviceAccountKeyBase64 = Deno.env.get('SERVICE_ACCOUNT_KEY_BASE64');
  if (!serviceAccountKeyBase64) {
    throw new Error('Service account key not set in environment variables');
  }

  // Decode the base64-encoded service account key
  const decodedServiceAccountKey = new TextDecoder().decode(base64Decode(serviceAccountKeyBase64));
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

  const signedJwt = ${unsignedJwt}.${encodedSignature};

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
  return tokenData.access_token;
}

// Helper function to trigger the persist purchase RPC
async function triggerPersistPurchaseRPC(
  transactionId: string,
  productId: string,
  purchaseToken: string,
  purchaseDate: number,
  countryCode: string
): Promise<any> {
  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  const supabase = createClient(supabaseUrl, supabaseKey);

  const { data, error } = await supabase.rpc('android_persist_purchase', {
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

function base64urlEncode(arraybuffer: ArrayBuffer): string {
  let base64 = btoa(String.fromCharCode(...new Uint8Array(arraybuffer)));
  return base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

// Helper function to convert PEM to ArrayBuffer
function pemToArrayBuffer(pem: string): ArrayBuffer {
  // Remove the "BEGIN" and "END" lines and newlines
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
