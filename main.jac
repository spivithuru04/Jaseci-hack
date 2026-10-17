import from "@jac/runtime" { Router, Routes, Route }
import from .components.BuildWiseDashboard { BuildWiseDashboard }
import ".styles.global.css";

def:pub app() -> JsxElement {
    return <Router><Routes><Route path="/" element={<BuildWiseDashboard />} /></Routes></Router>;
}
