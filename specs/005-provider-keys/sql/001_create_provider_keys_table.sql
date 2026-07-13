-- Provider Keys Table Schema
-- Feature: 005-provider-keys

-- Create provider_keys table
CREATE TABLE IF NOT EXISTS provider_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    provider VARCHAR(50) NOT NULL CHECK (provider IN ('openai', 'gemini')),
    vault_secret_id UUID NOT NULL, -- Reference to Supabase Vault secret
    is_active BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'invalid' CHECK (status IN ('valid', 'invalid', 'rate_limited')),
    last_validated_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE provider_keys ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view own provider keys" ON provider_keys
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own provider keys" ON provider_keys
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own provider keys" ON provider_keys
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own provider keys" ON provider_keys
    FOR DELETE USING (auth.uid() = user_id);

-- Create indexes
CREATE INDEX idx_provider_keys_user_id ON provider_keys(user_id);
CREATE INDEX idx_provider_keys_provider ON provider_keys(provider);
CREATE INDEX idx_provider_keys_is_active ON provider_keys(is_active) WHERE is_active = true;

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update updated_at
CREATE TRIGGER update_provider_keys_updated_at
    BEFORE UPDATE ON provider_keys
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Comments
COMMENT ON TABLE provider_keys IS 'Stores AI provider API keys (OpenAI, Gemini) securely using Supabase Vault';
COMMENT ON COLUMN provider_keys.provider IS 'The AI provider (openai or gemini)';
COMMENT ON COLUMN provider_keys.key_name IS 'User-provided name for identifying the key';
COMMENT ON COLUMN provider_keys.key_secret_id IS 'Reference to the secret stored in Supabase Vault';
COMMENT ON COLUMN provider_keys.is_active IS 'Whether this key is currently active for the provider';
COMMENT ON COLUMN provider_keys.is_valid IS 'Whether the key passed validation';
COMMENT ON COLUMN provider_keys.last_validated_at IS 'Timestamp of last validation check';