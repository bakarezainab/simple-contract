# Simple Escrow Contract

A trustless escrow system for secure peer-to-peer transactions between a buyer and seller, with a neutral third-party arbiter to resolve disputes. The contract was deployed to Base

## Overview

This smart contract enables safe transactions by holding funds in escrow until a trusted arbiter confirms that conditions have been met. Neither the buyer nor seller can unilaterally withdraw funds once deposited.

## How It Works

1. **Deploy** - Any party deploys the contract specifying buyer, seller, and arbiter addresses
2. **Deposit** - Buyer deposits ETH into the contract
3. **Arbiter Decides** - The arbiter either:
   - Releases funds to the seller (when work is completed)
   - Refunds the buyer (if there's a dispute or issue)
4. **Complete** - Funds are automatically transferred to the appropriate party

## Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd simple-contract

# Install Foundry (if not already installed)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install
```
# Deployment
## The contract was deployed to base sepolia
https://sepolia.basescan.org/tx/0x6951a11466ffb95d014281e1abc2aabfde7879aac3d464516fba3aa3c3217ff6

## Usage

### Deploy the Contract

1. Set up your `.env` file:
```bash
PRIVATE_KEY=0xyour_private_key_here
BUYER_ADDRESS=0x...
SELLER_ADDRESS=0x...
ARBITER_ADDRESS=0x...
BASE_SEPOLIA_RPC_URL=https://...
```

2. Deploy as buyer:
```bash
forge script script/DeployEscrow.s.sol:DeployAsBuyer \
    --rpc-url $BASE_SEPOLIA_RPC_URL \
    --broadcast \
    --verify
```

3. Deploy as seller:
```bash
forge script script/DeployEscrow.s.sol:DeployAsSeller \
    --rpc-url $BASE_SEPOLIA_RPC_URL \
    --broadcast \
    --verify
```

### Interact with the Contract

**Deposit funds (as buyer):**
```bash
cast send <ESCROW_ADDRESS> "deposit()" \
    --value 1ether \
    --private-key $PRIVATE_KEY \
    --rpc-url $BASE_SEPOLIA_RPC_URL
```

**Release funds to seller (as arbiter):**
```bash
cast send <ESCROW_ADDRESS> "releaseFunds()" \
    --private-key $ARBITER_PRIVATE_KEY \
    --rpc-url $BASE_SEPOLIA_RPC_URL
```

**Refund buyer (as arbiter):**
```bash
cast send <ESCROW_ADDRESS> "refundBuyer()" \
    --private-key $ARBITER_PRIVATE_KEY \
    --rpc-url $BASE_SEPOLIA_RPC_URL
```

**Check contract balance:**
```bash
cast call <ESCROW_ADDRESS> "getBalance()" \
    --rpc-url $BASE_SEPOLIA_RPC_URL
```

## Testing

Run the comprehensive test suite:

```bash
# Run all tests
forge test

# Run with verbosity
forge test -vvv

# Run specific test
forge test --match-test testDeposit

# Check gas usage
forge test --gas-report

# Check code coverage
forge coverage
```

## Contract Functions

| Function | Access | Description |
|----------|--------|-------------|
| `deposit()` | Buyer only | Deposit ETH into escrow |
| `releaseFunds()` | Arbiter only | Release funds to seller |
| `refundBuyer()` | Arbiter only | Refund funds to buyer |
| `getBalance()` | Public view | Check contract balance |

## Use Cases

- Freelance work payments
- Online marketplace transactions
- Service delivery agreements
- Real estate earnest money
- Any peer-to-peer deal requiring trust

## Project Structure

```
.
├── src/
│   └── Escrow.sol          # Main escrow contract
├── script/
│   └── DeployEscrow.s.sol  # Deployment scripts
└── README.md
```