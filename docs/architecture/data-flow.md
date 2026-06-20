Data Flow

Market Data Lifecycle

Public Exchanges
      │
      ▼
Data Collectors
      │
      ▼
Normalization Layer
      │
      ▼
Market Scanner
      │
      ▼
Opportunity Engine
      │
      ▼
Risk Validation
      │
      ▼
API Response
      │
      ▼
Frontend Dashboard

Data Sources

Binance

* Spot Market
* Ticker Data
* Market Statistics

Bybit

* Spot Market
* Market Prices
* Trading Volumes

OKX

* Spot Market
* Bid/Ask Data
* Volume Data

CoinGecko

* Market Validation
* Price Comparison
* Reference Pricing

⸻

Opportunity Detection Process

Step 1

Collect prices from all exchanges.

Step 2

Normalize all symbols.

Example:

BTC-USDT
BTCUSDT
BTC/USD

becomes:

BTCUSDT

Step 3

Find lowest available price.

Step 4

Find highest available price.

Step 5

Calculate spread.

Spread % =
((Highest Price - Lowest Price)
 / Lowest Price) × 100

Step 6

Filter opportunities below minimum threshold.

Step 7

Rank opportunities by profitability.

⸻

Important Considerations

Detected spread does not guarantee profit.

Execution must account for:

* Exchange Fees
* Withdrawal Fees
* Deposit Delays
* Slippage
* Liquidity
* Order Book Depth
* Latency
* Network Costs

Dashboard Flow

Scanner
  │
  ▼
API
  │
  ▼
React Dashboard
  │
  ├─ Portfolio
  ├─ Opportunities
  ├─ Statistics
  └─ Logs
