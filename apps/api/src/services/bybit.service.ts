import axios from "axios";
import { config } from "../config.js";
import { MarketSymbol, Ticker } from "../types.js";

const symbols: MarketSymbol[] = ["BTCUSDT", "ETHUSDT", "BNBUSDT", "SOLUSDT", "XRPUSDT"];

export async function getBybitTickers(): Promise<Ticker[]> {
  const response = await axios.get(`${config.bybitBaseUrl}/v5/market/tickers`, {
    params: { category: "spot" },
    timeout: 8000
  });

  const rows = response.data?.result?.list || [];

  return rows
    .filter((item: any) => symbols.includes(item.symbol))
    .map((item: any) => ({
      exchange: "Bybit",
      symbol: item.symbol,
      price: Number(item.lastPrice),
      bid: Number(item.bid1Price),
      ask: Number(item.ask1Price),
      change24h: Number(item.price24hPcnt) * 100,
      volume24h: Number(item.turnover24h),
      timestamp: Date.now()
    }));
}
