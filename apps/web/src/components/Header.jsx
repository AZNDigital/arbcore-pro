import { Activity } from "lucide-react";

export default function Header() {
  return (
    <header className="border-b border-slate-800 bg-slate-900">
      <div className="max-w-7xl mx-auto p-5 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Activity className="text-emerald-400" />

          <div>
            <h1 className="font-black text-xl">
              ArbCore Pro
            </h1>

            <p className="text-xs text-slate-400">
              Next Generation Arbitrage Infrastructure
            </p>
          </div>
        </div>

        <div className="text-emerald-400 text-sm font-bold">
          ONLINE
        </div>
      </div>
    </header>
  );
}
