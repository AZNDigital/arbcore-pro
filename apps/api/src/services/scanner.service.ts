import crypto from "crypto";
import { config } from "../config.js";
import { Opportunity, Ticker } from "../types.js";
import { getBinanceTickers } from "./binance.service.js";
import { getBybitTickers } from "./bybit.service.js";
import { getOkxTickers } from "./okx.service.js";
import { getCoinGeckoTickers } from "./coingecko.service.js";

export async function getAllTickers(): Promise<Ticker[]> {
  const results = await Promise.allSettled([
    getBinanceTickers(),
    getBybitTickers(),
    getOkxTickers(),
    getCoinGeckoTickers()
  ]);

  return results.flatMap((result) => {
    if (result.status === "fulfilled") return result.value;
    return [];
  });
}

export async function scanOpportunities(): Promise<Opportunity[]> {
  const tickers = await getAllTickers();
  const grouped = new Map<string, Ticker[]>();

  for (const ticker of tickers) {
    if (!ticker.price || ticker.price <= 0) continue;

    const list = grouped.get(ticker.symbol) || [];
    list.push(ticker);
    grouped.set(ticker.symbol, list);
  }

  const opportunities: Opportunity[] = [];

  for (const [symbol, list] of grouped.entries()) {
    if (list.length < 2) continue;

    const cheapest = [...list].sort((a, b) => a.price - b.price)[0];
    const highest = [...list].sort((a, b) => b.price - a.price)[0];

    if (!cheapest || !highest) continue;
    if (cheapest.exchange === highest.exchange) continue;

    const spreadPercent = ((highest.price - cheapest.price) / cheapest.price) * 100;

    if (spreadPercent < config.minSpreadPercent) continue;

    const tradeSize = config.maxTradeSizeUsdt;
    const estimatedProfitUsdt = tradeSize * (spreadPercent / 100);

    opportunities.push({
      id: crypto.randomUUID(),
      symbol: symbol as any,
      buyExchange: cheapest.exchange,
      sellExchange: highest.exchange,
      buyPrice: cheapest.price,
      sellPrice: highest.price,
      spreadPercent: Number(spreadPercent.toFixed(4)),
      estimatedProfitUsdt: Number(estimatedProfitUsdt.toFixed(2)),
      confidence: Math.min(99, Number((80 + spreadPercent * 5).toFixed(1))),
      timestamp: Date.now()
    });
  }

  return opportunities.sort((a, b) => b.spreadPercent - a.spreadPercent);
}
