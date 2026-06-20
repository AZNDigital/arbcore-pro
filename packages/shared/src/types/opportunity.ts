export interface ArbitrageOpportunity {
  id: string;
  symbol: string;

  buyExchange: string;
  sellExchange: string;

  buyPrice: number;
  sellPrice: number;

  spreadPercent: number;

  estimatedProfitUsdt: number;

  confidence: number;

  timestamp: number;
}
