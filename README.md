# Yield Aggregator Vault (Foundry)

A simple yield aggregator vault implementation inspired by ERC-4626 concepts.  
This project is built for learning and portfolio purposes, focusing on
vault–strategy separation, capital allocation, and test-driven development
using Foundry.

## Core Concepts

- Vault–Strategy architecture
- Deposit & withdraw flow
- Share-based accounting
- Mock strategy for yield simulation
- Full unit test coverage using Foundry

## Architecture Overview

### Vault
- Accepts user deposits
- Issues shares
- Manages strategy interaction

### Strategy (Mock)
- Simulates yield generation
- Reports total assets back to the vault
- Designed for testing and demo purposes only

## Project Structure

src/
├─ Vault.sol # Core vault logic
├─ interfaces/
│ └─ IERC20.sol # ERC20 interface
├─ mocks/
│ ├─ MockERC20.sol # Test token
│ └─ MockStrategy.sol # Simulated yield strategy

test/
├─ Vault.t.sol
├─ MockStrategy.t.sol
└─ MockERC20.t.sol

script/
└─ Deploy.s.sol # Deployment script

## Disclaimer

This project is for learning and portfolio purposes only.  
Not audited. Do not use in production.
