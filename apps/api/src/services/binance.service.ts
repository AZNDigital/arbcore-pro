import axios from "axios";
import { config } from "../config.js";
import { MarketSymbol, Ticker } from "../types.js";

const symbols: MarketSymbol[] = ["BTCUSDT", "ETHUSDT", "BNBUSDT", "SOLUSDT", "XRPUSDT"];

export async function getBinanceTickers(): Promise<Ticker[]> {
  const response = await axios.get(`${config.binanceBaseUrl}/api/v3/ticker/24hr`, {
    timeout: 8000
  });

  const rows = Array.isArray(response.data) ? response.data : [];

  return rows
    .filter((item) => symbols.includes(item.symbol))
    .map((item) => ({
      exchange: "Binance",
      symbol: item.symbol,
      price: Number(item.lastPrice),
      bid: Number(item.bidPrice),
      ask: Number(item.askPrice),
      change24h: Number(item.priceChangePercent),
      volume24h: Number(item.quoteVolume),
      timestamp: Date.now()
    }));
}
