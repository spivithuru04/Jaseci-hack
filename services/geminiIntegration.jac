import os;
import json;
import from google.genai { Client, types }

def _gemini_config() -> dict {
    key = os.environ.get("GEMINI_API_KEY", "");
    model = os.environ.get("GEMINI_MODEL", "gemini-2.5-flash");
    return {"configured": bool(key.strip()), "model": model, "key": key};
}

def:pub getGeminiStatus() -> dict {
    cfg = _gemini_config();
    return {"provider": "Google Gemini", "model": cfg["model"], "configured": cfg["configured"], "demo_mode": not cfg["configured"], "message": "Gemini key is configured on the server." if cfg["configured"] else "GEMINI_API_KEY is not set. Manual planning remains available; AI features are in demo mode."};
}

async def:pub extractProjectRequirements(description: str) -> dict {
    cfg = _gemini_config();
    if not cfg["configured"] {
        return {"ok": False, "demo_mode": True, "model": cfg["model"], "error": "Gemini is not configured. Add GEMINI_API_KEY in JacHammer Settings to use extraction."};
    }
    if not description.strip() or len(description) > 6000 {
        return {"ok": False, "demo_mode": False, "model": cfg["model"], "error": "Enter a project description of 1 to 6000 characters."};
    }
    try {
        client = Client(api_key=cfg["key"]);
        prompt = "Extract house requirements from this text. Return JSON only with keys bedrooms (integer or null), bathrooms (integer or null), floor_area (number or null), area_unit (string or null), budget_lkr (number or null), location (string or null), quality (Economy, Standard, Premium, or null), other_requirements (array of strings), unknowns (array of strings). Never infer absent values; use null and list missing facts in unknowns. User text: " + description;
        response = await client.aio.models.generate_content(model=cfg["model"], contents=prompt, config=types.GenerateContentConfig(response_mime_type="application/json", temperature=0.1));
        text = response.text or "";
        parsed = json.loads(text);
        return {"ok": True, "demo_mode": False, "model": cfg["model"], "requirements": parsed};
    } except Exception as err {
        message = str(err);
        safe_message = "Gemini request failed. Check API key, model availability, quota, or network, then retry.";
        if "429" in message or "RESOURCE_EXHAUSTED" in message { safe_message = "Gemini quota or rate limit reached. Try later or check the free-tier quota."; }
        elif "401" in message or "403" in message or "API_KEY_INVALID" in message { safe_message = "Gemini rejected the server API key. Check GEMINI_API_KEY in JacHammer Settings."; }
        elif "404" in message or "NOT_FOUND" in message { safe_message = "The configured Gemini model is unavailable to this API key. Check GEMINI_MODEL."; }
        return {"ok": False, "demo_mode": False, "model": cfg["model"], "error": safe_message};
    }
}
