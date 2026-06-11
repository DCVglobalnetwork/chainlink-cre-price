# UK Property CRE Workflow

This project demonstrates a Chainlink CRE workflow for verifying off-chain data and writing it on-chain.

---

## Flow

HTTP Request:
{ "token": "ETH" }

↓

Chainlink Data Feed (Sepolia ETH/USD)

↓

EVM Write to Snapshot contract

---

## Smart Contract

Stores:
- token
- price (from Chainlink Data Feed)
- blockNumber (oracle update block)
- timestamp

---

## Deploy (Sepolia)

Deploy `Snapshot.sol` using Remix:
- Network: Sepolia
- Constructor: your wallet address

---

## Run CRE Workflow

cre workflow simulate my-workflow --broadcast

---

## Environment

Copy `.env.example` and set:
- CONTRACT_ADDRESS
- RPC_URL
