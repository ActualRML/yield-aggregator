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

## Sepolia Deployment

- Vault: 0x10eF6C76429B494408983d402F98771e7A7974DC
- Strategy: 0xd3EBa1fd328245bfA52b3d323D185d694FCECFCB
- MockERC20: 0x134CC0F5D8E95E99e0befe8914e2B97b22cd5198

## Verified Deployment (Sepolia)

- Vault: 0x10eF6C76429B494408983d402F98771e7A7974DC  
- Strategy: 0xd3EBa1fd328245bfA52b3d323D185d694FCECFCB  
- Token: 0x134CC0F5D8E95E99e0befe8914e2B97b22cd5198

## Disclaimer

This project is for learning and portfolio purposes only.  
Not audited. Do not use in production.
