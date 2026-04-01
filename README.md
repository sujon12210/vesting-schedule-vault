# Vesting Schedule Vault (Team/Advisor)

A professional-grade treasury management tool. This repository implements a robust "Vesting" logic where tokens are locked and released gradually over time. It supports both a "Cliff" (a period where no tokens are released) and "Linear Vesting" (tokens unlock second-by-second after the cliff).

## Core Features
* **Cliff Period:** Lock 100% of tokens for a set duration (e.g., 1 year).
* **Linear Release:** Smooth, per-block or per-second unlocking to avoid supply shocks.
* **Revocable Vesting:** Optional admin power to stop vesting if a team member leaves.
* **Flat Structure:** Optimized for deployment by DAOs or startup founders.

## Logic Flow
1. **Initialize:** Deploy the vault with the ERC-20 token address.
2. **Grant:** Admin creates a vesting schedule for a user (Total Amount, Start, Cliff, Duration).
3. **Claim:** The user calls `release()` to pull currently unlocked tokens to their wallet.

## Setup
1. `npm install`
2. Deploy `TokenVesting.sol`.
