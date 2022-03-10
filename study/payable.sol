// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MobileBaking {

    address owner;
    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Error, Only Owner!!");
        _;
    }

    event SendInfo(address _msgSender, uint256 _currentValue);
    event MyCurrentValue(address _msgSender, uint256 _value);
    event CurrentValueOfSomeone(address _msgSender, address _to, uint256 _value);

    function sendKlay(address payable _to) public onlyOwner payable {
        require(msg.sender.balance >= msg.value, "Your balance is not enouth");
        _to.transfer(msg.value);
        emit SendInfo(msg.sender, msg.sender.balance);
    }

    function checkValueNow() public onlyOwner {
        emit MyCurrentValue(msg.sender, msg.sender.balance);
    }

    function checkUserMoney(address _to) public onlyOwner {
        emit CurrentValueOfSomeone(msg.sender, _to, _to.balance);
    }
}