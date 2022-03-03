// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8;

contract SimpleBank {
    mapping (address => uint) private balances;

    address public owner;
    event LogDepositMade(address accountAddress, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable returns (uint) {
        require((balances[msg.sender] + msg.value) >= balances[msg.sender]);
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    function withdraw(uint withdrawAmount) public returns (uint) {
        require(withdrawAmount <= balances[msg.sender]);
        balances[msg.sender] -= withdrawAmount;
        msg.sender.call{value:withdrawAmount, gas: 5000};
        return balances[msg.sender];
    }

    function balance() public view returns (uint) {
        return balances[msg.sender];
    }
}