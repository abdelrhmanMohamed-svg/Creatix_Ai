# Contracts: Brand Kit Wizard Edge Functions

## generate-brand-summary Edge Function

### Purpose
Generate an AI-powered brand summary based on the user's inputs from the brand kit wizard steps, using the same provider resolution system as the image generation feature.

### Request
```http
POST /functions/v1/generate-brand-summary
Content-Type: application/json
Authorization: Bearer <supabase-anon-key>

{
  "brand_id": "uuid",
  "business_type": "string",
  "tone_of_voice": "string", 
  "colors": ["string"],
  "target_audience": "string"
}
```

#### Request Fields
- `brand_id`: UUID (required) - The brand this summary is for
- `business_type`: String (required) - User-selected business type from wizard
- `tone_of_voice`: String (required) - User-selected tone of voice from wizard
- `colors`: Array of String (required) - User-selected colors (hex codes) from wizard
- `target_audience`: String (required) - User-defined target audience from wizard

### Response
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "summary": "string"
}
```

#### Response Fields
- `summary`: String - AI-generated brand summary based on the inputs

### Provider Resolution Logic (Same as image generation)
The edge function uses the exact same provider resolution system as the `generate-image` function:

1. Check if the user has an active API key for the given brand
2. If user key exists:
   - If provider is "openai": Use OpenAI API with user's key
   - If provider is "gemini": Use Gemini API with user's key
3. If no user key exists:
   - Use default provider (Pixazo) with system-held API key

### Error Responses
```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": "string"
}
```

```http
HTTP/1.1 500 Internal Server Error
Content-Type: application/json

{
  "error": "string"
}
```

### Security Considerations
- Must verify brand_id belongs to authenticated user (via brands table user_id)
- Must never expose API keys in logs or error messages
- Must validate all input fields before processing
- Must handle provider-specific API errors gracefully

### Implementation Notes
- Should reuse existing provider resolution helper functions if available
- Should follow same error handling patterns as generate-image function
- Should return summary in same format expected by frontend
- Must not exceed function execution time limits