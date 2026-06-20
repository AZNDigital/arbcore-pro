import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { config } from "./config.js";
import { healthRoutes } from "./routes/health.routes.js";
import { marketRoutes } from "./routes/market.routes.js";
import { executionRoutes } from "./routes/execution.routes.js";

const app = express();

app.use(helmet());
app.use(cors({ origin: config.corsOrigin }));
app.use(express.json({ limit: "1mb" }));
app.use(morgan("dev"));

app.use("/api", healthRoutes);
app.use("/api", marketRoutes);
app.use("/api", executionRoutes);

app.use((req, res) => {
  res.status(404).json({
    error: "Route not found",
    path: req.path
  });
});

app.use((error: unknown, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error(error);

  res.status(500).json({
    error: "Internal server error"
  });
});

app.listen(config.port, () => {
  console.log(`ArbCore API running on http://localhost:${config.port}`);
});
