cl def:pub MaterialPriceManager() -> JsxElement {
    has name: str = "";
    has category: str = "Cement";
    has specification: str = "";
    has unit: str = "Bag";
    has price: str = "";
    has supplier: str = "";
    has district: str = "";
    has date: str = "";
    has source: str = "Project Custom Price";
    has query: str = "";
    has filter: str = "All categories";
    has records: list[dict] = [];
    has status: str = "";
    has edit_index: int = -1;
    async can with entry {
        # jac:ignore[E1053]
        browser: any = globalThis as any;
        records = JSON.parse(str(browser.localStorage.getItem("buildwise-materials") or "[]")) as list[dict];
    }
    def on_name(e: ChangeEvent) { name = e.target.value; }
    def on_category(e: ChangeEvent) { category = e.target.value; }
    def on_specification(e: ChangeEvent) { specification = e.target.value; }
    def on_unit(e: ChangeEvent) { unit = e.target.value; }
    def on_price(e: ChangeEvent) { price = e.target.value; }
    def on_supplier(e: ChangeEvent) { supplier = e.target.value; }
    def on_district(e: ChangeEvent) { district = e.target.value; }
    def on_date(e: ChangeEvent) { date = e.target.value; }
    def on_source(e: ChangeEvent) { source = e.target.value; }
    def on_query(e: ChangeEvent) { query = e.target.value; }
    def on_filter(e: ChangeEvent) { filter = e.target.value; }
    def reset_form() { name = ""; specification = ""; price = ""; supplier = ""; district = ""; date = ""; edit_index = -1; }
    def save_price() {
        n = float(price) if price else -1.0;
        if not name.strip() or n < 0.0 {
            status = "Enter a material name and a valid non-negative unit price.";
        } else {
            item = {"name": name, "category": category, "specification": specification, "unit": unit, "price": price, "supplier": supplier, "district": district, "date": date, "source": source};
            if edit_index >= 0 {
                updated: list[dict] = [];
                for (i, old) in enumerate(records) { updated = updated + [item if i == edit_index else old]; }
                records = updated;
                status = "Material price updated in this browser.";
            } else {
                records = records + [item];
                status = "Material price saved in this browser.";
            }
            # jac:ignore[E1053]
            browser: any = globalThis as any;
            browser.localStorage.setItem("buildwise-materials", JSON.stringify(records));
            reset_form();
        }
    }
    def start_edit(index: int) {
        selected = records[index];
        name = str(selected["name"]);
        category = str(selected["category"]);
        specification = str(selected["specification"]);
        unit = str(selected["unit"]);
        price = str(selected["price"]);
        supplier = str(selected["supplier"]);
        district = str(selected["district"]);
        date = str(selected["date"]);
        source = str(selected["source"]);
        edit_index = index;
        status = "Editing selected material price.";
    }
    def delete_price(index: int) {
        records = [item for (i, item) in enumerate(records) if i != index];
        # jac:ignore[E1053]
        browser: any = globalThis as any;
        browser.localStorage.setItem("buildwise-materials", JSON.stringify(records));
        status = "Material price deleted from this browser.";
    }
    def export_csv() {
        status = "CSV export is not implemented in this local demo. Prices remain available in the table.";
    }
    return <main className="mx-auto flex max-w-7xl flex-col gap-6 px-4 py-7 sm:px-6"><header><p className="text-sm font-medium text-primary">BuildWise pricing workspace</p><h1 className="mt-1 text-2xl font-semibold tracking-tight">Material Price Manager</h1><p className="mt-1 text-sm text-muted-foreground">Enter prices from a source you know. User entries never overwrite reference or supplier data.</p></header>{status and <p role="status" className="rounded-lg border bg-card p-3 text-sm">{status}</p>}
        <section className="rounded-xl border bg-card shadow-sm"><header className="p-6"><h2 className="text-lg font-semibold">Add or edit a material price</h2><p className="text-sm text-muted-foreground">Every rate is labeled by source and date. Missing prices stay unavailable.</p></header><div className="grid gap-4 px-6 pb-6 sm:grid-cols-2 lg:grid-cols-3"><label className="flex flex-col gap-2 text-sm">Material name<input value={name} onChange={on_name} className="h-9 rounded-md border bg-background px-3" placeholder="e.g. Cement" /></label><label className="flex flex-col gap-2 text-sm">Category<select value={category} onChange={on_category} className="h-9 rounded-md border bg-background px-3"><option>Cement</option><option>Sand</option><option>Bricks</option><option>Concrete blocks</option><option>Reinforcement steel</option><option>Aggregates</option><option>Ready-mix concrete</option><option>Roofing</option><option>Timber</option><option>Floor tiles</option><option>Wall tiles</option><option>Paint</option><option>Doors</option><option>Windows</option><option>Electrical</option><option>Plumbing</option><option>Sanitary fittings</option><option>Ceiling</option><option>Waterproofing</option><option>Other</option></select></label><label className="flex flex-col gap-2 text-sm">Brand or specification<input value={specification} onChange={on_specification} className="h-9 rounded-md border bg-background px-3" placeholder="Optional" /></label><label className="flex flex-col gap-2 text-sm">Unit<select value={unit} onChange={on_unit} className="h-9 rounded-md border bg-background px-3"><option>Bag</option><option>Kilogram</option><option>Metric tonne</option><option>Cubic metre</option><option>Cubic foot</option><option>Square metre</option><option>Square foot</option><option>Piece</option><option>Litre</option><option>Metre</option></select></label><label className="flex flex-col gap-2 text-sm">Price per unit (LKR)<input type="number" min="0" step="0.01" value={price} onChange={on_price} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex flex-col gap-2 text-sm">Price source<select value={source} onChange={on_source} className="h-9 rounded-md border bg-background px-3"><option>Project Custom Price</option><option>Supplier Price</option><option>Admin Reference Price</option></select></label><label className="flex flex-col gap-2 text-sm">Supplier name (optional)<input value={supplier} onChange={on_supplier} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex flex-col gap-2 text-sm">Supplier district<input value={district} onChange={on_district} className="h-9 rounded-md border bg-background px-3" /></label><label className="flex flex-col gap-2 text-sm">Effective date<input type="date" value={date} onChange={on_date} className="h-9 rounded-md border bg-background px-3" /></label><div className="flex items-end gap-2"><button onClick={save_price} className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground">{ "Save price" if edit_index < 0 else "Update price"}</button>{edit_index >= 0 and <button onClick={reset_form} className="rounded-md border px-4 py-2 text-sm">Cancel edit</button>}</div></div></section>
        <section className="rounded-xl border bg-card shadow-sm"><header className="flex flex-col gap-4 p-6"><div className="flex flex-wrap items-end justify-between gap-3"><div><h2 className="text-lg font-semibold">Material price records</h2><p className="text-sm text-muted-foreground">Local records only; prices are not represented as verified market rates.</p></div><button onClick={export_csv} className="rounded-md border px-3 py-2 text-sm">Export CSV</button></div><div className="grid gap-3 sm:grid-cols-2"><input aria-label="Search material prices" value={query} onChange={on_query} placeholder="Search name, supplier, district" className="h-9 rounded-md border bg-background px-3 text-sm" /><select value={filter} onChange={on_filter} className="h-9 rounded-md border bg-background px-3 text-sm"><option>All categories</option><option>Cement</option><option>Sand</option><option>Bricks</option><option>Reinforcement steel</option><option>Roofing</option><option>Tiles</option><option>Other</option></select></div></header><div className="overflow-x-auto px-6 pb-6"><table className="w-full min-w-[760px] border-collapse text-left text-sm"><thead><tr className="border-b text-muted-foreground"><th className="p-3">Material</th><th className="p-3">Specification</th><th className="p-3">Unit</th><th className="p-3 text-right">Price (LKR)</th><th className="p-3">Supplier / district</th><th className="p-3">Updated</th><th className="p-3">Source / actions</th></tr></thead><tbody>{if len(records) == 0 { <tr><td colSpan="7" className="p-8 text-center text-muted-foreground">No price records. Price not available until you add a sourced entry.</td></tr>; skip; }}{for (i, item) in enumerate(records) {if (filter == "All categories" or filter == str(item["category"])) and (query.strip() == "" or query.lower() in str(item["name"]).lower() or query.lower() in str(item["supplier"]).lower() or query.lower() in str(item["district"]).lower()) {<tr key={str(i)} className="border-b last:border-0"><td className="p-3 font-medium">{item["name"]}<span className="block text-xs text-muted-foreground">{item["category"]}</span></td><td className="p-3">{item["specification"]}</td><td className="p-3">{item["unit"]}</td><td className="p-3 text-right tabular-nums">{item["price"]}</td><td className="p-3">{item["supplier"]}<span className="block text-xs text-muted-foreground">{item["district"]}</span></td><td className="p-3">{item["date"] or "Not dated"}</td><td className="p-3"><span className="block text-xs text-muted-foreground">{item["source"]}</span><div className="mt-2 flex gap-3"><button onClick={lambda { start_edit(i); }} className="text-primary">Edit</button><button onClick={lambda { delete_price(i); }} className="text-destructive">Delete</button></div></td></tr>}}}</tbody></table></div></section>
        <p className="text-xs text-muted-foreground">CSV import, shared admin reference rate controls, supplier identity checks, and automatic BOQ integration require authenticated backend services and are not available in this local demo.</p>
    </main>;
}
