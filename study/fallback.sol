// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Bank {
    event JustFallbackWithFunds (address _from, uint256 _value, string message);
    event JustFallback(address _from, string message);
    event ReceiveFallback(address _from, uint256 _value, string message);
    
    // fallback() external payable {
    //     emit JustFallbackWithFunds(msg.sender, msg.value, "JustFallbackWithFunds is called");
    // }

    fallback() external payable {
        emit JustFallback(msg.sender, "JustFallback is called");
    }

    receive() external payable {
        emit ReceiveFallback(msg.sender, msg.value, "ReceiveFallback is called");
    }
}

contract You {
    function DepositWithSend (address payable _to) public payable {
        bool success = _to.send(msg.value);
        require(success, "Failed");
    }

    function DepositWithTransfer (address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function DepositWithCall (address payable _to) public payable {
        // ~ 0.7
        //(bool sent, ) = _to.call.value(msg.value)("");
        //require(sent, "Failed to send klay");

        // 0.7 ~
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed");
    }

    // fallback
    function JustGiveMessage(address _to) public {
        (bool sent, ) = _to.call("HI");
        require(sent, "Failed");
    }

    // fallback with funds
    function JustGiveMessageWithFunds(address _to) public payable {
        (bool sent, ) = _to.call{value:msg.value}("HI");
        require(sent, "Failed");
    }
}