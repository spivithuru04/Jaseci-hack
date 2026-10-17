import os;
import from jaclang.byllm.lib { Model }

glob openai_model: Model = Model(model_name=os.environ.get("OPENAI_MODEL", "gpt-4o-mini"));

obj ProjectInterpretation {
    has room_count: int | None = None;
    has bedrooms: int | None = None;
    has bathrooms: int | None = None;
    has location: str | None = None;
    has requested_area: float | None = None;
    has quality: str | None = None;
    has budget_lkr: float | None = None;
    has unknowns: list[str] = [];
}
sem ProjectInterpretation = "Structured fields explicitly stated in a residential construction brief. Never invent missing values; list them in unknowns.";
sem ProjectInterpretation.room_count = "Total rooms stated explicitly, or null.";
sem ProjectInterpretation.bedrooms = "Bedrooms explicitly stated, or null.";
sem ProjectInterpretation.bathrooms = "Bathrooms explicitly stated, or null.";
sem ProjectInterpretation.location = "Sri Lankan city or district explicitly stated, or null.";
sem ProjectInterpretation.requested_area = "Floor area stated explicitly, or null.";
sem ProjectInterpretation.quality = "Economy, Standard, or Premium only if stated, otherwise null.";
sem ProjectInterpretation.budget_lkr = "Budget stated explicitly in LKR, or null.";
sem ProjectInterpretation.unknowns = "Important construction information absent from the text.";

def interpretProjectDescription(description: str) -> ProjectInterpretation by openai_model(temperature=0.0, max_tokens=250, max_output_retries=0);
sem interpretProjectDescription = "Extract explicitly stated requirements from a house construction description. Do not calculate quantities or prices, and do not infer missing facts.";
sem interpretProjectDescription.description = "House owner's natural-language project description, up to 4000 characters.";

async def:pub getOpenAIStatus() -> dict {
    configured = bool(os.environ.get("OPENAI_API_KEY", "").strip());
    model = os.environ.get("OPENAI_MODEL", "gpt-4o-mini");
    return {"provider": "OpenAI", "model": model, "configured": configured, "demo_mode": not configured, "message": "OpenAI is configured on the server; interpretation is optional." if configured else "OPENAI_API_KEY is not configured. Local estimation remains available."};
}

async def:pub analyzeProjectDescription(description: str) -> dict {
    configured = bool(os.environ.get("OPENAI_API_KEY", "").strip());
    model = os.environ.get("OPENAI_MODEL", "gpt-4o-mini");
    if not configured { return {"ok": False, "demo_mode": True, "model": model, "error": "OpenAI unavailable; continue with local deterministic estimation."}; }
    if not description.strip() or len(description) > 4000 { return {"ok": False, "demo_mode": False, "model": model, "error": "Description must contain 1 to 4000 characters."}; }
    try {
        details = interpretProjectDescription(description);
        return {"ok": True, "demo_mode": False, "model": model, "interpretation": details};
    } except Exception as err {
        message = str(err);
        safe_message = "OpenAI request failed. Local estimate is still available.";
        if "429" in message or "RateLimit" in message or "quota" in message.lower() { safe_message = "OpenAI rate limit or credit quota reached. Local estimate is still available."; }
        elif "401" in message or "Authentication" in message or "invalid_api_key" in message { safe_message = "OpenAI rejected the server key. Check OPENAI_API_KEY in JacHammer Settings."; }
        return {"ok": False, "demo_mode": False, "model": model, "error": safe_message};
    }
}
