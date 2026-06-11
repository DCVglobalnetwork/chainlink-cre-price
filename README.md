# CRE Price Snapshot System

This project demonstrates a Chainlink CRE workflow that:

1. Accepts a token input via HTTP
2. Reads Chainlink Data Feed (Sepolia ETH/USD)
3. Retrieves latest price and block number
4. Writes snapshot data on-chain via smart contract

## Contract

Deployed on Sepolia:
`0xYourDeployedContractAddress`

## Workflow

- EVM Read: Chainlink Price Feed
- EVM Write: Snapshot.sol

## Run Command (CRE)

cre workflow simulate priceSnapshot --broadcast
