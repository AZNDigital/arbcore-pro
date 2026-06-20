export interface MarketTicker {
  exchange: string;
  symbol: string;
  price: number;
  bid?: number;
  ask?: number;
  volume24h?: number;
  change24h?: number;
  timestamp: number;
}
