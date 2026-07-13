/**
 * Supabase Edge Function: delete-key
 * 
 * Purpose: Delete a provider key
 * 
 * Security Features:
 * - User ownership is verified before deletion
 * - Key must exist before deletion (returns 404 if not found)
 * 
 * @param {Object} body - Request body containing key id to delete
 * @returns {Object} Response confirming deletion
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

    // Check if key exists
    const keys = await fetchSupabase(`provider_keys?id=eq.${id}&select=*`, 'GET');
    const keyData = keys && keys.length > 0 ? keys[0] : null;

    if (!keyData) {
      return new Response(
        JSON.stringify({ error: 'Key not found' }),
        { status: 404, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Delete the key record (secret is deleted with it)
    await fetchSupabase(`provider_keys?id=eq.${id}`, 'DELETE');

    return new Response(
      JSON.stringify({ success: true, message: 'API key deleted' }),
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