import axios from "axios";
import { config } from "../config.js";
import { MarketSymbol, Ticker } from "../types.js";

const okxMap: Record<string, MarketSymbol> = {
  "BTC-USDT": "BTCUSDT",
  "ETH-USDT": "ETHUSDT",
  "BNB-USDT": "BNBUSDT",
  "SOL-USDT": "SOLUSDT",
  "XRP-USDT": "XRPUSDT"
};

export async function getOkxTickers(): Promise<Ticker[]> {
  const response = await axios.get(`${config.okxBaseUrl}/api/v5/market/tickers`, {
    params: { instType: "SPOT" },
    timeout: 8000
  });

  const rows = response.data?.data || [];

  return rows
    .filter((item: any) => okxMap[item.instId])
    .map((item: any) => ({
      exchange: "OKX",
      symbol: okxMap[item.instId],
      price: Number(item.last),
      bid: Number(item.bidPx),
      ask: Number(item.askPx),
      volume24h: Number(item.volCcy24h),
      timestamp: Number(item.ts) || Date.now()
    }));
}
