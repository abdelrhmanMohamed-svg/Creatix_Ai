/**
 * Supabase Edge Function: get-active-key
 * 
 * Purpose: Retrieve the active API key for a specific provider
 * 
 * NOTE: This function returns the secret for server-side use only.
 * It should only be called from trusted server-side contexts (other edge functions)
 * when making actual AI provider API calls.
 * 
 * Security Features:
 * - Only returns active and valid keys
 * - Requires both userId and provider in request
 * - Key must be both active and valid to be returned
 * 
 * @param {Object} body - Request body containing userId and provider
 * @returns {Object} Response containing the active key secret (for server use only)
 */
const SUPABASE_SERVICE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

const fetchSupabase = async (endpoint: string, method: string, body?: object) => {
  const response = await fetch(`${SUPABASE_URL}/rest/v1/${endpoint}`, {
    method,
    headers: {
      'apikey': SUPABASE_SERVICE_KEY,
      'Authorization': `Bearer ${SUPABASE_SERVICE_KEY}`,
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  const data = await response.json();
  if (!response.ok && response.status !== 409) {
    throw new Error(data.message || data.error || 'Request failed');
  }
  return data;
};

const handler = async (req: Request): Promise<Response> => {
  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify({ error: 'Method not allowed' }),
      { status: 405, headers: { 'Content-Type': 'application/json' } }
    );
  }

  try {
    const body = await req.json();
    const { userId, provider } = body;

    if (!userId || !provider) {
      return new Response(
        JSON.stringify({ error: 'User ID and provider are required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Get the active key for the provider
    const keys = await fetchSupabase(
      `provider_keys?user_id=eq.${userId}&provider=eq.${provider}&is_active=eq.true&is_valid=eq.true&select=*`,
      'GET'
    );

    const keyData = keys && keys.length > 0 ? keys[0] : null;

    if (!keyData) {
      return new Response(
        JSON.stringify({ 
          error: 'No active key found',
          secret: null 
        }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Return the secret directly from the database
    return new Response(
      JSON.stringify({
        success: true,
        secret: keyData.secret,
        provider: keyData.provider,
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
};

Deno.serve(handler)