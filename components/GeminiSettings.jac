sv import from ..services.geminiIntegration { getGeminiStatus, extractProjectRequirements }

cl def:pub GeminiSettings() -> JsxElement {
    has brief: str = "";
    has provider: str = "Google Gemini";
    has model: str = "gemini-2.5-flash";
    has configured: bool = False;
    has demo_mode: bool = True;
    has message: str = "Checking server configuration...";
    has result: str = "";
    has loading: bool = True;
    has busy: bool = False;
    async can with entry {
        try {
            status = await getGeminiStatus();
            provider = str(status["provider"]);
            model = str(status["model"]);
            configured = status["configured"] as bool;
            demo_mode = status["demo_mode"] as bool;
            message = str(status["message"]);
        } except Exception {
            message = "Could not reach the server status endpoint.";
            demo_mode = True;
        }
        loading = False;
    }
    def update_brief(e: ChangeEvent) { brief = e.target.value; }
    async def test_extraction() {
        if not brief.strip() {
            result = "Enter a short house description to test extraction.";
        } else {
            busy = True;
            try {
                response = await extractProjectRequirements(brief);
                result = JSON.stringify(response, None, 2);
            } except Exception {
                result = "The extraction request failed. Try again or check server configuration.";
            }
            busy = False;
        }
    }
    return <main className="mx-auto flex w-full max-w-5xl flex-col gap-6 px-4 py-7 sm:px-6"><header><p className="text-sm font-medium text-primary">BuildWise integration settings</p><h1 className="mt-1 text-2xl font-semibold tracking-tight">AI provider status</h1><p className="mt-1 text-sm text-muted-foreground">Server-side Gemini status and a simple requirements extraction check.</p></header>
        <section className="rounded-xl border bg-card p-6 shadow-sm"><h2 className="text-lg font-semibold">Connection status</h2>{loading and <p className="mt-3 text-sm text-muted-foreground">Loading server configuration...</p>}{not loading and <div className="mt-4 flex flex-col gap-4"><div className="grid gap-4 sm:grid-cols-2"><div className="rounded-lg border bg-muted/30 p-4"><p className="text-xs text-muted-foreground">Provider</p><p className="mt-1 font-medium">{provider}</p></div><div className="rounded-lg border bg-muted/30 p-4"><p className="text-xs text-muted-foreground">Configured model</p><p className="mt-1 font-medium">{model}</p></div><div className="rounded-lg border bg-muted/30 p-4"><p className="text-xs text-muted-foreground">API key status</p><p className="mt-1 font-medium">{"Configured on server" if configured else "Not configured"}</p></div><div className="rounded-lg border bg-muted/30 p-4"><p className="text-xs text-muted-foreground">Mode</p><p className="mt-1 font-medium">{ "Demo mode" if demo_mode else "Gemini available"}</p></div></div><p role="status" className="rounded-lg border p-3 text-sm text-muted-foreground">{message}</p></div>}</section>
        <section className="rounded-xl border bg-card p-6 shadow-sm"><h2 className="text-lg font-semibold">Requirements extraction test</h2><p className="mt-1 text-sm text-muted-foreground">The server requests structured fields and marks missing information unknown. No prices or measurements are inferred.</p><label className="mt-5 flex flex-col gap-2 text-sm font-medium">House description<textarea value={brief} onChange={update_brief} className="min-h-32 rounded-md border bg-background px-3 py-2 font-normal" placeholder="Example: A 3-bedroom home in Kandy, about 140 square metres, Standard finish. Budget is not decided." /></label><button onClick={test_extraction} disabled={busy or loading} className="mt-4 rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground disabled:opacity-50">{ "Requesting Gemini..." if busy else "Test requirements extraction"}</button>{result and <pre className="mt-4 max-h-96 overflow-auto whitespace-pre-wrap rounded-lg border bg-muted/30 p-4 text-sm">{result}</pre>}</section>
        <aside className="rounded-xl border border-dashed p-5 text-sm text-muted-foreground"><p className="font-medium text-foreground">Credential security</p><p className="mt-1">Set GEMINI_API_KEY in JacHammer Settings under Environment. The value is read by the server only and is never displayed here. Optional model override: GEMINI_MODEL. Default: gemini-2.5-flash.</p><p className="mt-2">This project previously had only unused OpenAI configuration, not an OpenAI API integration. Gemini extraction is the only live AI feature added here. Costs, plan interpretation, recommendations, and directory matching remain manual or deterministic; no Gemini response is presented as a verified quantity, price, or professional approval.</p></aside>
    </main>;
}
