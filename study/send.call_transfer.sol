// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract SendCallTransfer {
     event howMuch(uint256 _value);

     function sendNow(address payable _to) public payable {
         bool sent = _to.send(msg.value);
         require(sent, "Failed to send klay");
         emit howMuch(msg.value);
     }

     function transferNow(address payable _to) public payable {
         _to.transfer(msg.value);
         emit howMuch(msg.value);
     }

     function callNow(address payable _to) public payable {
         (bool sent, ) = _to.call{value:msg.value, gas:1000}("");
         require(sent, "Faild to send klay");
         emit howMuch(msg.value);
     }
     
}
 
