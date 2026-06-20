import { config } from "../config.js";
import { ExecutionResult, Opportunity } from "../types.js";

export function paperExecute(opportunity: Opportunity): ExecutionResult {
  if (config.executionMode !== "paper") {
    return {
      mode: "disabled",
      status: "rejected",
      opportunityId: opportunity.id,
      reason: "Real execution is disabled. Use paper mode until audits and risk checks are completed.",
      timestamp: Date.now()
    };
  }

  if (opportunity.estimatedProfitUsdt <= 0) {
    return {
      mode: "paper",
      status: "rejected",
      opportunityId: opportunity.id,
      reason: "Opportunity is not profitable.",
      timestamp: Date.now()
    };
  }

  return {
    mode: "paper",
    status: "accepted",
    opportunityId: opportunity.id,
    estimatedProfitUsdt: opportunity.estimatedProfitUsdt,
    timestamp: Date.now()
  };
}
