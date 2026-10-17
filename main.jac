import from services.openaiIntegration { getOpenAIStatus, analyzeProjectDescription }
import from "@jac/runtime" { Router, Routes, Route, Link }
import from .components.BuildWiseDashboard { BuildWiseDashboard }
import from .components.Companies { Companies }
import from .components.Workers { Workers }
import from .components.MaterialPriceManager { MaterialPriceManager }
import from .components.OpenAISettings { OpenAISettings }
import from .components.EstimateResults { EstimateResults }
import ".styles.global.css";

def:pub AppFrame(children: any = None) -> JsxElement {
    return <div className="min-h-screen bg-muted/40"><nav className="border-b bg-background"><div className="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-3 px-4 py-3 sm:px-6"><Link to="/" className="font-semibold tracking-tight">BuildWise</Link><div className="flex flex-wrap gap-2 text-sm"><Link to="/" className="rounded-md px-3 py-2 hover:bg-muted">Project</Link><Link to="/estimate" className="rounded-md px-3 py-2 hover:bg-muted">Estimates</Link><Link to="/companies" className="rounded-md px-3 py-2 hover:bg-muted">Companies</Link><Link to="/workers" className="rounded-md px-3 py-2 hover:bg-muted">Workers</Link><Link to="/materials" className="rounded-md px-3 py-2 hover:bg-muted">Material prices</Link><Link to="/settings/ai" className="rounded-md px-3 py-2 hover:bg-muted">AI settings</Link></div></div></nav>{children}</div>;
}

def:pub app() -> JsxElement {
    return <Router><Routes><Route path="/" element={<AppFrame><BuildWiseDashboard /></AppFrame>} /><Route path="/companies" element={<AppFrame><Companies /></AppFrame>} /><Route path="/workers" element={<AppFrame><Workers /></AppFrame>} /><Route path="/materials" element={<AppFrame><MaterialPriceManager /></AppFrame>} /><Route path="/settings/ai" element={<AppFrame><OpenAISettings /></AppFrame>} /><Route path="/estimate" element={<AppFrame><EstimateResults /></AppFrame>} /></Routes></Router>;
}
