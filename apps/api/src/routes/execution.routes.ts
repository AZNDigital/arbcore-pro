import { Router } from "express";
import { z } from "zod";
import { paperExecute } from "../services/execution.service.js";
import { scanOpportunities } from "../services/scanner.service.js";

export const executionRoutes = Router();

const executeSchema = z.object({
  opportunityId: z.string().min(1)
});

executionRoutes.post("/execute", async (req, res, next) => {
  try {
    const body = executeSchema.parse(req.body);
    const opportunities = await scanOpportunities();
    const opportunity = opportunities.find((item) => item.id === body.opportunityId);

    if (!opportunity) {
      return res.status(404).json({
        error: "Opportunity not found or expired."
      });
    }

    const result = paperExecute(opportunity);
    return res.json(result);
  } catch (error) {
    next(error);
  }
});
