// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Escrow.sol";

contract DeployEscrow is Script {
    function run() external returns (Escrow) {
        // Load environment variables
        address seller = vm.envAddress("SELLER_ADDRESS");
        address arbiter = vm.envAddress("ARBITER_ADDRESS");
        
        // Get the deployer's private key
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the Escrow contract
        Escrow escrow = new Escrow(seller, arbiter);

        console.log("Escrow deployed at:", address(escrow));
        console.log("Buyer (deployer):", msg.sender);
        console.log("Seller:", seller);
        console.log("Arbiter:", arbiter);

        vm.stopBroadcast();

        return escrow;
    }
}

// Alternative: Deploy with constructor arguments passed directly
contract DeployEscrowWithArgs is Script {
    function run(address seller, address arbiter) external returns (Escrow) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        Escrow escrow = new Escrow(seller, arbiter);

        console.log("Escrow deployed at:", address(escrow));
        console.log("Buyer (deployer):", msg.sender);
        console.log("Seller:", seller);
        console.log("Arbiter:", arbiter);

        vm.stopBroadcast();

        return escrow;
    }
}

// For local testing with Anvil
contract DeployEscrowLocal is Script {
    function run() external returns (Escrow) {
        // Default Anvil test accounts
        address buyer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address seller = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        address arbiter = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

        vm.startBroadcast(buyer);

        Escrow escrow = new Escrow(seller, arbiter);

        console.log("=== Local Deployment ===");
        console.log("Escrow deployed at:", address(escrow));
        console.log("Buyer:", buyer);
        console.log("Seller:", seller);
        console.log("Arbiter:", arbiter);

        vm.stopBroadcast();

        return escrow;
    }
}