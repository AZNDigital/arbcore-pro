API Design

Base URL

http://localhost:8080/api

Health Endpoint

Request

GET /health

Response

{
  "status": "ok",
  "service": "arbcore-api"
}

⸻

Market Tickers

Request

GET /tickers

Response

{
  "data": [
    {
      "exchange": "Binance",
      "symbol": "BTCUSDT",
      "price": 68450.25
    }
  ]
}

⸻

Arbitrage Opportunities

Request

GET /opportunities

Response

{
  "data": [
    {
      "id": "uuid",
      "symbol": "BTCUSDT",
      "buyExchange": "Bybit",
      "sellExchange": "Binance",
      "spreadPercent": 0.42,
      "estimatedProfitUsdt": 4.20
    }
  ]
}

⸻

Statistics

Request

GET /stats

Response

{
  "balance": 49500,
  "mode": "paper",
  "opportunities": 5
}

⸻

Execution Endpoint

Request

POST /execute

Body

{
  "opportunityId": "uuid"
}

Response

{
  "status": "accepted",
  "mode": "paper"
}

Execution Modes

Paper Mode

* No real orders
* No real funds
* Simulation only

Future Live Mode

* Exchange APIs
* Smart Contracts
* Risk Validation
* Trade Limits
