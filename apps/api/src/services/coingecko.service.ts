import axios from "axios";
import { config } from "../config.js";
import { Ticker } from "../types.js";

const coinMap = {
  bitcoin: "BTCUSDT",
  ethereum: "ETHUSDT",
  binancecoin: "BNBUSDT",
  solana: "SOLUSDT",
  ripple: "XRPUSDT"
} as const;

export async function getCoinGeckoTickers(): Promise<Ticker[]> {
  const response = await axios.get(`${config.coinGeckoBaseUrl}/simple/price`, {
    params: {
      ids: Object.keys(coinMap).join(","),
      vs_currencies: "usd",
      include_24hr_change: "true",
      include_24hr_vol: "true",
      include_last_updated_at: "true"
    },
    timeout: 8000
  });

  return Object.entries(coinMap).map(([coinId, symbol]) => {
    const row = response.data?.[coinId];

    return {
      exchange: "CoinGecko",
      symbol,
      price: Number(row?.usd || 0),
      change24h: Number(row?.usd_24h_change || 0),
      volume24h: Number(row?.usd_24h_vol || 0),
      timestamp: Number(row?.last_updated_at ? row.last_updated_at * 1000 : Date.now())
    };
  });
}
