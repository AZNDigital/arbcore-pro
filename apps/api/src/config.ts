import dotenv from "dotenv";

dotenv.config();

export const config = {
  port: Number(process.env.API_PORT || 8080),
  corsOrigin: process.env.CORS_ORIGIN || "http://localhost:5173",

  binanceBaseUrl: process.env.BINANCE_BASE_URL || "https://api.binance.com",
  bybitBaseUrl: process.env.BYBIT_BASE_URL || "https://api.bybit.com",
  okxBaseUrl: process.env.OKX_BASE_URL || "https://www.okx.com",
  coinGeckoBaseUrl: process.env.COINGECKO_BASE_URL || "https://api.coingecko.com/api/v3",

  executionMode: process.env.EXECUTION_MODE || "paper",
  minSpreadPercent: Number(process.env.MIN_SPREAD_PERCENT || 0.12),
  maxTradeSizeUsdt: Number(process.env.MAX_TRADE_SIZE_USDT || 1000)
};
