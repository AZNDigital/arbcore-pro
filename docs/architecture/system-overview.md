System Overview

High-Level Architecture

┌────────────────────────────────────┐
│         ArbCore Web Dashboard      │
│         React + Tailwind           │
└─────────────────┬──────────────────┘
                  │
                  ▼
┌────────────────────────────────────┐
│             API Layer              │
│       Express + TypeScript         │
└─────────────────┬──────────────────┘
                  │
                  ▼
┌────────────────────────────────────┐
│          Market Scanner            │
│ Binance • Bybit • OKX • CoinGecko  │
└─────────────────┬──────────────────┘
                  │
                  ▼
┌────────────────────────────────────┐
│         Execution Engine           │
│ Paper Mode / Future Live Mode      │
└─────────────────┬──────────────────┘
                  │
                  ▼
┌────────────────────────────────────┐
│       Smart Contract Layer         │
│ Solidity • Flash Loans • Treasury  │
└────────────────────────────────────┘

Platform Components

Frontend

Responsibilities:

* Dashboard
* Portfolio View
* Market Monitoring
* Opportunity Tracking
* Trade History
* System Monitoring

Backend API

Responsibilities:

* Market Data Aggregation
* Opportunity Detection
* Risk Validation
* Trade Simulation
* Future Order Execution

Smart Contracts

Responsibilities:

* Treasury Management
* Flash Loan Execution
* Risk Enforcement
* Permission Control
* Emergency Controls

Design Goals

* Modular Development
* Easy Maintenance
* Security First
* High Availability
* Future Multi-Chain Support
