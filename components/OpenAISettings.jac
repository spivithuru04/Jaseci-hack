sv import from ..services.openaiIntegration { getOpenAIStatus, analyzeProjectDescription }

cl def:pub OpenAISettings() -> JsxElement {
    has model: str = "gpt-4o-mini";
    has configured: bool = False;
    has demo_mode: bool = True;
    has message: str = "Checking server configuration...";
    has brief: str = "";
    has result: str = "";
    has loading: bool = True;
    has busy: bool = False;
    async can with entry {
        try {
            status = await getOpenAIStatus();
            model = str(status["model"]);
            configured = status["configured"] as bool;
            demo_mode = status["demo_mode"] as bool;
            message = str(status["message"]);
        } except Exception {
            message = "OpenAI status could not be reached. Local estimation remains available.";
        }
        loading = False;
    }
    def update_brief(e: ChangeEvent) { brief = e.target.value; }
    async def analyze_brief() {
        if not brief.strip() { result = "Enter a brief to test the optional description interpreter."; }
        else {
            busy = True;
            try {
                response = await analyzeProjectDescription(brief);
                result = JSON.stringify(response, None, 2);
            } except Exception { result = "OpenAI is unavailable. Continue with the local estimate."; }
            busy = False;
        }
    }
    return <main className="mx-auto flex w-full max-w-5xl flex-col gap-6 px-4 py-7 sm:px-6"><header><p className="text-sm font-medium text-primary">BuildWise settings</p><h1 className="mt-1 text-2xl font-semibold tracking-tight">OpenAI integration status</h1><p className="mt-1 text-sm text-muted-foreground">Optional text interpretation. The deterministic estimate works without OpenAI.</p></header>
        <section className="rounded-xl border bg-card p-6 shadow-sm"><h2 className="text-lg font-semibold">Server configuration</h2>{loading and <p className="mt-3 text-sm text-muted-foreground">Loading status...</p>}{not loading and <div className="mt-4 grid gap-4 sm:grid-cols-2"><div className="rounded-lg border bg-muted/30 p-4"><p className="text-xs text-muted-foreground">Provider</p><p className="mt-1 font-medium">OpenAI</p></div><div className="rounded-lg border bg-muted/30 p-4"><p className="text-xs text-muted-foreground">Configured model</p><p className="mt-1 font-medium">{model}</p></div><div className="rounded-lg border bg-muted/30 p-4"><p className="text-xs text-muted-foreground">API key status</p><p className="mt-1 font-medium">{"Configured on server" if configured else "Not configured"}</p></div><div className="rounded-lg border bg-muted/30 p-4"><p className="text-xs text-muted-foreground">Mode</p><p className="mt-1 font-medium">{"Demo mode" if demo_mode else "Optional AI enabled"}</p></div><p role="status" className="rounded-lg border p-3 text-sm text-muted-foreground sm:col-span-2">{message}</p></div>}</section>
        <section className="rounded-xl border bg-card p-6 shadow-sm"><h2 className="text-lg font-semibold">Optional description interpretation test</h2><p className="mt-1 text-sm text-muted-foreground">One compact request extracts only explicit fields. It does not calculate quantities or prices.</p><label className="mt-5 flex flex-col gap-2 text-sm font-medium">House description<textarea value={brief} onChange={update_brief} className="min-h-28 rounded-md border bg-background px-3 py-2 font-normal" placeholder="Describe rooms, requested area, district, and budget if known." /></label><button onClick={analyze_brief} disabled={busy or loading} className="mt-4 rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground disabled:opacity-50">{"Requesting OpenAI..." if busy else "Interpret description"}</button>{result and <pre className="mt-4 max-h-80 overflow-auto whitespace-pre-wrap rounded-lg border bg-muted/30 p-4 text-sm">{result}</pre>}</section>
        <aside className="rounded-xl border border-dashed p-5 text-sm text-muted-foreground"><p className="font-medium text-foreground">Credential handling</p><p className="mt-1">Add OPENAI_API_KEY in JacHammer Settings under Environment. Optional OPENAI_MODEL overrides gpt-4o-mini. The key is read server-side and is never displayed or sent from the browser.</p><p className="mt-2">This application has only a manually selected plan filename and no 2D geometry editor. Uploaded drawings are not sent or interpreted. The estimator does not create structural quantities or claim verified supplier prices.</p></aside>
    </main>;
}
