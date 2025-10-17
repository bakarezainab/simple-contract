// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter;
    uint256 public amount;
    bool public fundsDeposited;
    bool public released;
    bool public refunded;

    event FundsDeposited(address indexed buyer, uint256 amount);
    event FundsReleased(address indexed seller, uint256 amount);
    event FundsRefunded(address indexed buyer, uint256 amount);

    error OnlyBuyer();
    error OnlyArbiter();
    error AlreadyDeposited();
    error NoFundsDeposited();
    error AlreadyCompleted();
    error IncorrectAmount();

    constructor(address _seller, address _arbiter) {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
    }

    function deposit() external payable {
        if (msg.sender != buyer) revert OnlyBuyer();
        if (fundsDeposited) revert AlreadyDeposited();
        if (msg.value == 0) revert IncorrectAmount();

        amount = msg.value;
        fundsDeposited = true;

        emit FundsDeposited(msg.sender, msg.value);
    }

    function releaseFunds() external {
        if (msg.sender != arbiter) revert OnlyArbiter();
        if (!fundsDeposited) revert NoFundsDeposited();
        if (released || refunded) revert AlreadyCompleted();

        released = true;
        
        (bool success, ) = seller.call{value: amount}("");
        require(success, "Transfer failed");

        emit FundsReleased(seller, amount);
    }

    function refundBuyer() external {
        if (msg.sender != arbiter) revert OnlyArbiter();
        if (!fundsDeposited) revert NoFundsDeposited();
        if (released || refunded) revert AlreadyCompleted();

        refunded = true;
        
        (bool success, ) = buyer.call{value: amount}("");
        require(success, "Transfer failed");

        emit FundsRefunded(buyer, amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}