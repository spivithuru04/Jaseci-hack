cl def:pub BuildWiseDashboard() -> JsxElement {
    has project_name: str = "New Sri Lankan home";
    has area: str = "1200";
    has budget: str = "18000000";
    has rate: str = "14500";
    has quality: str = "Standard";
    has unit: str = "sq ft";
    has description: str = "";
    has saved: str = "";
    has filename: str = "";
    has preview: str = "";
    def set_name(e: ChangeEvent) { project_name = e.target.value; }
    def set_area(e: ChangeEvent) { area = e.target.value; }
    def set_budget(e: ChangeEvent) { budget = e.target.value; }
    def set_rate(e: ChangeEvent) { rate = e.target.value; }
    def set_quality(e: ChangeEvent) { quality = e.target.value; }
    def set_unit(e: ChangeEvent) { unit = e.target.value; }
    def set_description(e: ChangeEvent) { description = e.target.value; }
    def set_file(e: ChangeEvent) {
        chosen = e.target.files[0];
        filename = chosen.name;
        if chosen.type == "image/png" or chosen.type == "image/jpeg" {
            preview = URL.createObjectURL(chosen);
            saved = "Image ready for manual review; no measurements extracted.";
        } elif chosen.type == "application/pdf" {
            preview = "";
            saved = "PDF selected. Measurements remain unverified.";
        } else {
            filename = "";
            saved = "Select a PDF, PNG, or JPG.";
        }
    }
    def save_local() { saved = "Project details ready in this session. Local project persistence is not connected yet."; }
    a = float(area) if area else 0.0;
    b = float(budget) if budget else 0.0;
    r = float(rate) if rate else 0.0;
    total = a * r;
    sqm = a if unit == "sq m" else a * 0.092903;
    balance = b - total;
    return <div className="min-h-screen bg-muted/40"><header className="border-b bg-background"><div className="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 sm:px-6"><div><p className="font-semibold">BuildWise</p><p className="text-xs text-muted-foreground">Sri Lanka house planner</p></div><span className="rounded-full border px-2 py-1 text-xs text-muted-foreground">Local demo</span></div></header>
        <main className="mx-auto flex max-w-7xl flex-col gap-6 px-4 py-7 sm:px-6"><div className="flex flex-wrap items-end justify-between gap-4"><div><h1 className="text-2xl font-semibold tracking-tight">Project planning workspace</h1><p className="mt-1 text-sm text-muted-foreground">Editable project inputs and a transparent early estimate.</p></div><button onClick={save_local} className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground shadow-sm">Save project</button></div>
        {saved and <p role="status" className="rounded-lg border bg-card px-4 py-3 text-sm">{saved}</p>}
        <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><article className="rounded-xl border bg-card p-5 shadow-sm"><p className="text-sm text-muted-foreground">Planning estimate</p><p className="mt-2 text-2xl font-semibold tabular-nums">{f"LKR {total:.0f}"}</p><p className="mt-1 text-xs text-muted-foreground">Demonstration rate, not a quote</p></article><article className="rounded-xl border bg-card p-5 shadow-sm"><p className="text-sm text-muted-foreground">Floor area</p><p className="mt-2 text-2xl font-semibold tabular-nums">{f"{sqm:.1f}"} m²</p></article><article className="rounded-xl border bg-card p-5 shadow-sm"><p className="text-sm text-muted-foreground">Budget position</p><p className="mt-2 text-2xl font-semibold tabular-nums">{f"LKR {balance:.0f}"}</p><p className="mt-1 text-xs text-muted-foreground">Budget less estimate</p></article><article className="rounded-xl border bg-card p-5 shadow-sm"><p className="text-sm text-muted-foreground">Specification</p><p className="mt-2 text-2xl font-semibold">{quality}</p></article></section>
        <div className="grid gap-6 xl:grid-cols-5"><section className="rounded-xl border bg-card shadow-sm xl:col-span-3"><header className="flex flex-col gap-1 p-6"><h2 className="text-lg font-semibold">Project details</h2><p className="text-sm text-muted-foreground">Editable planning inputs for this session.</p></header><div className="flex flex-col gap-5 px-6 pb-6"><label className="flex flex-col gap-2 text-sm font-medium">Project name<input value={project_name} onChange={set_name} className="h-9 rounded-md border bg-background px-3 font-normal" /></label><label className="flex flex-col gap-2 text-sm font-medium">Project description<textarea value={description} onChange={set_description} placeholder="Rooms, site conditions, priorities" className="min-h-24 rounded-md border bg-background px-3 py-2 font-normal" /></label><div className="grid gap-4 sm:grid-cols-2"><label className="flex flex-col gap-2 text-sm font-medium">Gross floor area<input type="number" min="0" value={area} onChange={set_area} className="h-9 rounded-md border bg-background px-3 font-normal" /></label><label className="flex flex-col gap-2 text-sm font-medium">Area units<select value={unit} onChange={set_unit} className="h-9 rounded-md border bg-background px-3 font-normal"><option>sq ft</option><option>sq m</option></select></label><label className="flex flex-col gap-2 text-sm font-medium">Target budget (LKR)<input type="number" min="0" value={budget} onChange={set_budget} className="h-9 rounded-md border bg-background px-3 font-normal" /></label><label className="flex flex-col gap-2 text-sm font-medium">Specification tier<select value={quality} onChange={set_quality} className="h-9 rounded-md border bg-background px-3 font-normal"><option>Economy</option><option>Standard</option><option>Premium</option></select></label></div>
        <div className="rounded-lg border bg-muted/30 p-4"><p className="mb-3 font-medium">Floor plan</p><label htmlFor="plan" className="flex cursor-pointer flex-col items-center gap-2 rounded-lg border border-dashed bg-background px-4 py-6 text-center"><span className="text-sm font-medium">Choose PDF, PNG, or JPG</span><span className="text-xs text-muted-foreground">Manual review only; no automatic drawing interpretation.</span><input id="plan" type="file" accept="application/pdf,image/png,image/jpeg" onChange={set_file} className="sr-only" /></label>{filename and <div className="mt-3 rounded-md bg-background p-3 text-sm"><p>{filename}</p>{preview and <img src={preview} alt="Uploaded plan for manual review" className="mt-3 max-h-96 w-full rounded border object-contain" />}{not preview and <p className="mt-2 text-xs text-muted-foreground">PDF selected. Dimensions are unknown until calibrated.</p>}</div>}</div><p className="rounded-lg border border-dashed p-4 text-sm text-muted-foreground">Measurement provenance: user-provided. Architectural plans alone do not confirm structural quantities.</p></div></section>
        <div className="flex flex-col gap-6 xl:col-span-2"><section className="rounded-xl border bg-card shadow-sm"><header className="flex flex-col gap-1 p-6"><h2 className="text-lg font-semibold">Early cost model</h2><p className="text-sm text-muted-foreground">Area × editable demonstration rate</p></header><div className="flex flex-col gap-4 px-6 pb-6"><label className="flex flex-col gap-2 text-sm font-medium">Demo rate per {unit} (LKR)<input type="number" min="0" value={rate} onChange={set_rate} className="h-9 rounded-md border bg-background px-3 font-normal" /></label><div className="flex justify-between border-t pt-4 text-sm"><span>Illustrative total</span><strong className="tabular-nums">{f"LKR {total:.0f}"}</strong></div><p className="rounded-md border p-3 text-xs leading-relaxed text-muted-foreground">Sample rate is not verified current market data, a BSR rate, or a supplier quote. Excludes structural design quantities, regional factors, taxes, contingency, and professional review.</p></div></section><section className="rounded-xl border bg-card shadow-sm"><header className="flex flex-col gap-1 p-6"><h2 className="text-lg font-semibold">Before using a cost plan</h2><p className="text-sm text-muted-foreground">Planning information to verify</p></header><div className="flex flex-col gap-3 px-6 pb-6 text-sm"><p>Confirm district and site access conditions.</p><p>Enter room and opening dimensions from a scaled plan.</p><p>Use dated regional rates or confirmed supplier quotations.</p><p>Get engineer-supplied assumptions for structural items.</p></div></section><section className="rounded-xl border border-dashed bg-card p-5"><p className="font-medium">Supplier information unavailable</p><p className="mt-1 text-sm text-muted-foreground">No live directory is connected. Unknown prices remain unknown.</p></section></div></div><footer className="border-t pt-4 text-xs text-muted-foreground">Session-only demo. Estimates are not certified BOQs.</footer></main></div>;
}
