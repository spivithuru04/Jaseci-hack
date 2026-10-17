def:pub calculateEstimate(area: float, area_unit: str, budget: float, demo_rate: float, quality: str, location: str, description: str, plan_name: str) -> dict {
    if area <= 0.0 or demo_rate < 0.0 or budget < 0.0 {
        return {"ok": False, "error": "Area must be positive, and budget and rate must not be negative."};
    }
    area_sqm = area if area_unit == "sq m" else area * 0.092903;
    area_sqft = area if area_unit == "sq ft" else area * 10.7639104167;
    total = area * demo_rate;
    cost_per_sqft = total / area_sqft if area_sqft > 0.0 else 0.0;
    return {"ok": True, "area_sqm": area_sqm, "area_sqft": area_sqft, "budget": budget, "demo_rate": demo_rate, "quality": quality, "location": location, "description": description, "plan_name": plan_name, "total": total, "cost_per_sqft": cost_per_sqft, "budget_balance": budget - total, "material_cost": None, "labor_cost": None, "transport_cost": None, "contingency": None, "source": "User-entered demonstration rate", "assumptions": ["Planning total is gross floor area multiplied by the user-editable demonstration rate.", "This is not a sourced market rate, quote, or certified BOQ."], "unknowns": ["No measured room/wall/opening geometry is available from the uploaded file in this app.", "Material quantities and prices are unavailable unless entered in the material manager; that browser-local data is not exposed to the server.", "Labor rates and crew-days are unavailable.", "Transport, taxes, contingency, soil conditions, roof configuration, and structural design quantities are not included."]};
}
