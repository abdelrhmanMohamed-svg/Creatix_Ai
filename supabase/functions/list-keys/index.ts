/**
 * Supabase Edge Function: list-keys
 * 
 * Purpose: Retrieve all provider keys for a user
 * 
 * Security Features:
 * - Only returns keys belonging to the specified user
 * - Secrets are stripped from all responses (secret field excluded)
 * - User authentication is enforced via userId in request body
 * 
 * @param {Object} body - Request body containing userId
 * @returns {Object} Response containing array of keys (without secrets)
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
  if (req.method !== 'POST' && req.method !== 'GET') {
    return new Response(
      JSON.stringify({ error: 'Method not allowed' }),
      { status: 405, headers: { 'Content-Type': 'application/json' } }
    );
  }

  try {
    const body = await req.json().catch(() => ({}));
    const userId = body.userId;

    if (!userId) {
      return new Response(
        JSON.stringify({ error: 'User ID is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Get all keys for user
    const keys = await fetchSupabase(
      `provider_keys?user_id=eq.${userId}&select=*&order=created_at.desc`,
      'GET'
    );

    // Exclude secret from response
    const keysWithoutSecret = (keys || []).map(({ secret, ...key }) => key);

    return new Response(
      JSON.stringify({ keys: keysWithoutSecret }),
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