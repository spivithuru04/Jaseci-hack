cl def:pub Companies() -> JsxElement {
    has name: str = "";
    has category: str = "Construction company";
    has contact: str = "";
    has phone: str = "";
    has district: str = "";
    has description: str = "";
    has query: str = "";
    has records: list[dict] = [];
    has status: str = "";
    async can with entry {
        # jac:ignore[E1053]
        browser: any = globalThis as any;
        records = JSON.parse(str(browser.localStorage.getItem("buildwise-companies") or "[]")) as list[dict];
    }
    def update_name(e: ChangeEvent) { name = e.target.value; }
    def update_category(e: ChangeEvent) { category = e.target.value; }
    def update_contact(e: ChangeEvent) { contact = e.target.value; }
    def update_phone(e: ChangeEvent) { phone = e.target.value; }
    def update_district(e: ChangeEvent) { district = e.target.value; }
    def update_description(e: ChangeEvent) { description = e.target.value; }
    def update_query(e: ChangeEvent) { query = e.target.value; }
    def save_company() {
        if not name.strip() or not contact.strip() {
            status = "Company name and contact person are required.";
        } else {
            item = {"name": name, "category": category, "contact": contact, "phone": phone, "district": district, "description": description, "status": "Pending Verification"};
            records = records + [item];
            # jac:ignore[E1053]
            browser: any = globalThis as any;
            browser.localStorage.setItem("buildwise-companies", JSON.stringify(records));
            status = "Saved locally. Status: Pending Verification.";
            name = "";
            contact = "";
            phone = "";
            district = "";
            description = "";
        }
    }
    def delete_company(index: int) {
        records = [item for (i, item) in enumerate(records) if i != index];
        # jac:ignore[E1053]
        browser: any = globalThis as any;
        browser.localStorage.setItem("buildwise-companies", JSON.stringify(records));
        status = "Company entry removed from this browser.";
    }
    return <main className="mx-auto flex max-w-6xl flex-col gap-6 px-4 py-7 sm:px-6"><header><p className="text-sm font-medium text-primary">BuildWise directory</p><h1 className="mt-1 text-2xl font-semibold tracking-tight">Company registration</h1><p className="mt-1 text-sm text-muted-foreground">Register a business profile. Local entries are not publicly listed or verified.</p></header>{status and <p role="status" className="rounded-lg border bg-card p-3 text-sm">{status}</p>}
        <section className="rounded-xl border bg-card shadow-sm"><header className="p-6"><h2 className="text-lg font-semibold">Business profile</h2><p className="text-sm text-muted-foreground">Registration does not grant verified status.</p></header><div className="grid gap-4 px-6 pb-6 sm:grid-cols-2"><label className="flex flex-col gap-2 text-sm">Company name<input value={name} onChange={update_name} className="h-9 rounded-md border bg-background px-3" placeholder="Registered or trading name" /></label><label className="flex flex-col gap-2 text-sm">Company category<select value={category} onChange={update_category} className="h-9 rounded-md border bg-background px-3"><option>Construction company</option><option>Building contractor</option><option>Material supplier</option><option>Hardware store</option><option>Architectural firm</option><option>Civil engineering consultant</option><option>Quantity surveying service</option><option>Electrical and plumbing</option><option>Roofing company</option><option>Interior design</option><option>Equipment rental</option></select></label><label className="flex flex-col gap-2 text-sm">Contact person<input value={contact} onChange={update_contact} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex flex-col gap-2 text-sm">Business phone<input value={phone} onChange={update_phone} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex flex-col gap-2 text-sm">District<input value={district} onChange={update_district} className="h-9 rounded-md border bg-background px-3" placeholder="Service location" /></label><label className="flex flex-col gap-2 text-sm sm:col-span-2">Description<textarea value={description} onChange={update_description} className="min-h-20 rounded-md border bg-background px-3 py-2" /></label><button onClick={save_company} className="w-fit rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground">Save company profile</button></div></section>
        <section className="rounded-xl border bg-card shadow-sm"><header className="flex flex-wrap items-end justify-between gap-3 p-6"><div><h2 className="text-lg font-semibold">Saved company profiles</h2><p className="text-sm text-muted-foreground">Browser-local records; contact is not published.</p></div><input value={query} onChange={update_query} placeholder="Search companies" className="h-9 w-full max-w-xs rounded-md border bg-background px-3 text-sm" /></header><div className="flex flex-col gap-3 px-6 pb-6">{if len(records) == 0 { <p className="rounded-lg border border-dashed p-8 text-center text-sm text-muted-foreground">No company profiles yet. Add a company to begin.</p>; skip; }}{for (i, item) in enumerate(records) {if query.strip() == "" or query.lower() in str(item["name"]).lower() {<article key={str(i)} className="flex flex-wrap items-center justify-between gap-3 rounded-lg border p-4"><div><p className="font-medium">{item["name"]}</p><p className="text-sm text-muted-foreground">{item["category"]} · {item["district"]}</p><p className="mt-1 text-xs text-muted-foreground">Contact {item["contact"]} · {item["phone"]}</p></div><div className="flex items-center gap-3"><span className="rounded-full border px-2 py-1 text-xs">Pending Verification</span><button onClick={lambda { delete_company(i); }} className="text-sm text-destructive">Delete</button></div></article>}}}</div></section>
        <p className="text-xs text-muted-foreground">This registration form is a local demo only. It does not create an authenticated company account, verify evidence, or publish business contact details.</p>
    </main>;
}
