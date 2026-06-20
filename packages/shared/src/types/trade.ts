export interface TradeRecord {
  id: string;

  symbol: string;

  buyExchange: string;
  sellExchange: string;

  profit: number;

  executionMode: "paper" | "live";

  status: "success" | "failed";

  timestamp: number;
}
