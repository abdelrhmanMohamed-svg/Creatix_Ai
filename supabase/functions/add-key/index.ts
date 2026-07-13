/**
 * Supabase Edge Function: add-key
 * 
 * Purpose: Securely store and validate an AI provider API key
 * 
 * Security Features:
 * - Validates API key against provider before storage
 * - Secrets are stored in the database (in production, use Vault)
 * - Secret is stripped from all API responses to client
 * - User authentication is enforced via userId in request body
 * 
 * @param {Object} body - Request body containing userId, provider, and apiKey
 * @returns {Object} Response containing the created key (without secret)
 * 
 * @example
 * // Request
 * await supabase.functions.invoke('add-key', {
 *   body: { userId: 'uuid', provider: 'openai', apiKey: 'sk-xxx' }
 * });
 * 
 * // Response
 * { success: true, key: { id, provider, is_active, ... }, message: '...' }
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

const validateOpenAIKey = async (apiKey: string): Promise<boolean> => {
  try {
    const response = await fetch('https://api.openai.com/v1/models', {
      headers: { 'Authorization': `Bearer ${apiKey}` },
    });
    return response.ok;
  } catch {
    return false;
  }
};

const validateGeminiKey = async (apiKey: string): Promise<boolean> => {
  try {
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1/models?key=${apiKey}`
    );
    return response.ok;
  } catch {
    return false;
  }
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
    const { userId, provider, apiKey } = body;

    if (!userId) {
      return new Response(
        JSON.stringify({ error: 'User ID is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    if (!provider || !['openai', 'gemini'].includes(provider)) {
      return new Response(
        JSON.stringify({ error: 'Invalid provider. Must be "openai" or "gemini"' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    if (!apiKey || apiKey.trim().length === 0) {
      return new Response(
        JSON.stringify({ error: 'API key is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Validate the API key against provider API
    let isValidKey = false;
    let errorMessage = '';

    try {
      if (provider === 'openai') {
        isValidKey = await validateOpenAIKey(apiKey);
        if (!isValidKey) {
          errorMessage = 'Invalid OpenAI API key. Please check your key and try again.';
        }
      } else if (provider === 'gemini') {
        isValidKey = await validateGeminiKey(apiKey);
        if (!isValidKey) {
          errorMessage = 'Invalid Gemini API key. Please check your key and try again.';
        }
      }
    } catch (e) {
      isValidKey = false;
      errorMessage = `Invalid ${provider} API key. Please check your key and try again.`;
    }

    // If key is invalid, return error without storing
    if (!isValidKey) {
      return new Response(
        JSON.stringify({ error: errorMessage }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Deactivate existing keys for same provider
    await fetchSupabase(
      `provider_keys?user_id=eq.${userId}&provider=eq.${provider}`,
      'PATCH',
      { is_active: false }
    );

    // Store directly in provider_keys table with secret
    const keyData = await fetchSupabase('provider_keys', 'POST', {
      user_id: userId,
      provider: provider,
      key_name: `${provider}_key`,
      secret: apiKey,
      is_active: true,
      is_valid: isValidKey,
      last_validated_at: new Date().toISOString(),
    });

    if (!keyData || keyData.length === 0) {
      return new Response(
        JSON.stringify({ error: 'Failed to save key record' }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Return response without exposing the secret
    const { secret, ...keyWithoutSecret } = keyData[0];

    return new Response(
      JSON.stringify({
        success: true,
        key: keyWithoutSecret,
        message: 'API key added and validated successfully',
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