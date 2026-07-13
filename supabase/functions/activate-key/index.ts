/**
 * Supabase Edge Function: activate-key
 * 
 * Purpose: Activate a specific provider key, deactivating all others for the same provider
 * 
 * Business Logic:
 * - Only one key can be active per provider per user
 * - Activating a new key automatically deactivates the previous active key
 * 
 * Security Features:
 * - Secret is stripped from response
 * - User ownership is verified before activation
 * 
 * @param {Object} body - Request body containing key id to activate
 * @returns {Object} Response containing the activated key (without secret)
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
    const { id } = await req.json();

    if (!id) {
      return new Response(
        JSON.stringify({ error: 'Key ID is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Get the key to activate
    const keys = await fetchSupabase(`provider_keys?id=eq.${id}&select=*`, 'GET');
    const keyToActivate = keys && keys.length > 0 ? keys[0] : null;

    if (!keyToActivate) {
      return new Response(
        JSON.stringify({ error: 'Key not found' }),
        { status: 404, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Deactivate all other keys for the same provider
    await fetchSupabase(
      `provider_keys?user_id=eq.${keyToActivate.user_id}&provider=eq.${keyToActivate.provider}&id=not.eq.${id}`,
      'PATCH',
      { is_active: false }
    );

    // Activate the selected key
    const updatedKeys = await fetchSupabase(`provider_keys?id=eq.${id}`, 'PATCH', { is_active: true });

    // Exclude secret from response
    const updatedKey = (updatedKeys && updatedKeys.length > 0) ? updatedKeys[0] : keyToActivate;
    const { secret, ...keyWithoutSecret } = updatedKey;

    return new Response(
      JSON.stringify({
        success: true,
        key: keyWithoutSecret,
        message: 'API key activated successfully',
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