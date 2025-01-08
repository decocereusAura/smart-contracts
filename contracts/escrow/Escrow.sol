// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {

    error NotArbiter();

    address public arbiter; 
    address public beneficiary;
    address public depositor;
    bool public isApproved;
    uint256 serviceAmount;

    event Approved(uint serviceAmount,uint256 timestamp);

    modifier runByArbiter {
        if(msg.sender != arbiter) revert NotArbiter();
        _;
    }

    constructor (address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter; // gamp 
        beneficiary = _beneficiary; // end user 
        depositor = msg.sender; // tournament 
        serviceAmount = msg.value;
    }

    function approve() external runByArbiter {
        isApproved = true;
        (bool success,) = beneficiary.call{value: serviceAmount}("");
        require(success);
        emit Approved(serviceAmount, block.timestamp);
    }
}