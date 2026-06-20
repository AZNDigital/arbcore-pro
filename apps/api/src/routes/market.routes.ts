import { Router } from "express";
import { getAllTickers, scanOpportunities } from "../services/scanner.service.js";

export const marketRoutes = Router();

marketRoutes.get("/tickers", async (_req, res, next) => {
  try {
    const tickers = await getAllTickers();
    res.json({ data: tickers, count: tickers.length });
  } catch (error) {
    next(error);
  }
});

marketRoutes.get("/opportunities", async (_req, res, next) => {
  try {
    const opportunities = await scanOpportunities();
    res.json({ data: opportunities, count: opportunities.length });
  } catch (error) {
    next(error);
  }
});

marketRoutes.get("/stats", async (_req, res, next) => {
  try {
    const opportunities = await scanOpportunities();

    res.json({
      balance: 49500,
      mode: "paper",
      opportunities: opportunities.length,
      bestSpread: opportunities[0]?.spreadPercent || 0,
      estimatedBestProfit: opportunities[0]?.estimatedProfitUsdt || 0,
      timestamp: Date.now()
    });
  } catch (error) {
    next(error);
  }
});
