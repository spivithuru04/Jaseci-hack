cl def:pub Workers() -> JsxElement {
    has name: str = "";
    has profession: str = "Mason";
    has experience: str = "";
    has phone: str = "";
    has district: str = "";
    has rate: str = "";
    has consent: bool = False;
    has records: list[dict] = [];
    has status: str = "";
    async can with entry {
        # jac:ignore[E1053]
        browser: any = globalThis as any;
        records = JSON.parse(str(browser.localStorage.getItem("buildwise-workers") or "[]")) as list[dict];
    }
    def update_name(e: ChangeEvent) { name = e.target.value; }
    def update_profession(e: ChangeEvent) { profession = e.target.value; }
    def update_experience(e: ChangeEvent) { experience = e.target.value; }
    def update_phone(e: ChangeEvent) { phone = e.target.value; }
    def update_district(e: ChangeEvent) { district = e.target.value; }
    def update_rate(e: ChangeEvent) { rate = e.target.value; }
    def update_consent(e: ChangeEvent) { consent = e.target.checked; }
    def save_worker() {
        if not name.strip() or not district.strip() {
            status = "Name and service district are required.";
        } else {
            item = {"name": name, "profession": profession, "experience": experience, "phone": phone if consent else "", "district": district, "rate": rate, "consent": consent, "status": "Unverified"};
            records = records + [item];
            # jac:ignore[E1053]
            browser: any = globalThis as any;
            browser.localStorage.setItem("buildwise-workers", JSON.stringify(records));
            status = "Worker profile saved locally and marked Unverified.";
            name = "";
            experience = "";
            phone = "";
            district = "";
            rate = "";
            consent = False;
        }
    }
    def delete_worker(index: int) {
        records = [item for (i, item) in enumerate(records) if i != index];
        # jac:ignore[E1053]
        browser: any = globalThis as any;
        browser.localStorage.setItem("buildwise-workers", JSON.stringify(records));
        status = "Worker entry removed from this browser.";
    }
    return <main className="mx-auto flex max-w-6xl flex-col gap-6 px-4 py-7 sm:px-6"><header><p className="text-sm font-medium text-primary">BuildWise directory</p><h1 className="mt-1 text-2xl font-semibold tracking-tight">Worker registration</h1><p className="mt-1 text-sm text-muted-foreground">Build a local service profile and choose whether to include a contact number.</p></header>{status and <p role="status" className="rounded-lg border bg-card p-3 text-sm">{status}</p>}
        <section className="rounded-xl border bg-card shadow-sm"><header className="p-6"><h2 className="text-lg font-semibold">Professional profile</h2><p className="text-sm text-muted-foreground">Profiles remain Unverified. Contact details are saved only with explicit consent.</p></header><div className="grid gap-4 px-6 pb-6 sm:grid-cols-2"><label className="flex flex-col gap-2 text-sm">Full name<input value={name} onChange={update_name} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex flex-col gap-2 text-sm">Profession<select value={profession} onChange={update_profession} className="h-9 rounded-md border bg-background px-3"><option>Mason</option><option>Carpenter</option><option>Electrician</option><option>Plumber</option><option>Painter</option><option>Welder</option><option>Roofer</option><option>Tile installer</option><option>General construction labourer</option><option>Machine operator</option><option>Site supervisor</option><option>Quantity surveyor</option><option>Civil engineer</option><option>Architect</option><option>Other construction profession</option></select></label><label className="flex flex-col gap-2 text-sm">Years of experience<input type="number" min="0" value={experience} onChange={update_experience} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex flex-col gap-2 text-sm">Daily labour rate (LKR)<input type="number" min="0" value={rate} onChange={update_rate} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex flex-col gap-2 text-sm">Service district<input value={district} onChange={update_district} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex flex-col gap-2 text-sm">Phone number<input value={phone} onChange={update_phone} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex items-center gap-2 text-sm sm:col-span-2"><input type="checkbox" checked={consent} onChange={update_consent} />I consent to including this phone number in this local profile.</label><button onClick={save_worker} className="w-fit rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground">Save worker profile</button></div></section>
        <section className="rounded-xl border bg-card shadow-sm"><header className="p-6"><h2 className="text-lg font-semibold">Registered workers</h2><p className="text-sm text-muted-foreground">Only consented contact details are included.</p></header><div className="flex flex-col gap-3 px-6 pb-6">{if len(records) == 0 { <p className="rounded-lg border border-dashed p-8 text-center text-sm text-muted-foreground">No worker profiles yet. Register a worker to start a local directory.</p>; skip; }}{for (i, item) in enumerate(records) {<article key={str(i)} className="flex flex-wrap items-center justify-between gap-3 rounded-lg border p-4"><div><p className="font-medium">{item["name"]}</p><p className="text-sm text-muted-foreground">{item["profession"]} · {item["district"]} · {item["experience"]} years</p><p className="mt-1 text-xs text-muted-foreground">{item["phone"]}</p></div><div className="flex items-center gap-3"><span className="rounded-full border px-2 py-1 text-xs">Unverified</span><span className="text-sm tabular-nums">{item["rate"]} LKR/day</span><button onClick={lambda { delete_worker(i); }} className="text-sm text-destructive">Delete</button></div></article>}}</div></section>
        <p className="text-xs text-muted-foreground">This is a browser-local profile list, not a secure account, identity check, or public worker directory. Do not enter sensitive personal information.</p>
    </main>;
}
