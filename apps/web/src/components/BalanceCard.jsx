export default function BalanceCard() {
  return (
    <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
      <p className="text-slate-400">
        Portfolio Balance
      </p>

      <h2 className="text-5xl font-black mt-2">
        $0.00
      </h2>

      <p className="text-emerald-400 mt-2">
        +0.00 USDT
      </p>
    </div>
  );
}
