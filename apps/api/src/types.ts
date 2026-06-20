export type ExchangeName = "Binance" | "Bybit" | "OKX" | "CoinGecko";

export type MarketSymbol = "BTCUSDT" | "ETHUSDT" | "BNBUSDT" | "SOLUSDT" | "XRPUSDT";

export interface Ticker {
  exchange: ExchangeName;
  symbol: MarketSymbol;
  price: number;
  bid?: number;
  ask?: number;
  change24h?: number;
  volume24h?: number;
  timestamp: number;
}

export interface Opportunity {
  id: string;
  symbol: MarketSymbol;
  buyExchange: ExchangeName;
  sellExchange: ExchangeName;
  buyPrice: number;
  sellPrice: number;
  spreadPercent: number;
  estimatedProfitUsdt: number;
  confidence: number;
  timestamp: number;
}

export interface ExecutionResult {
  mode: "paper" | "disabled";
  status: "accepted" | "rejected";
  opportunityId: string;
  reason?: string;
  estimatedProfitUsdt?: number;
  timestamp: number;
}
