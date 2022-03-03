// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Ownable {
    address payable owner;
    constructor() {
        owner = payable(msg.sender);
    }

    modifier Owned {
        require(msg.sender == owner);
        _;
    }
}

contract Mortal is Ownable {
    function destroy() public Owned {
        selfdestruct(owner);
    }
}

contract Betting is Mortal {
    uint minBet;
    uint winRate;

    event Won(bool _result, uint _amout);

    constructor(uint _minBet, uint _winRate) {
        require(_minBet > 0);
        require(_winRate <= 100);
        minBet = _minBet;
        winRate = _winRate;
    }

    function random() private view returns(uint){
        uint source = block.difficulty + block.timestamp;
        bytes memory source_b = toBytes(source);
        return uint(keccak256(source_b)) % 5 + 1;
    }

    function toBytes(uint256 x) private pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }

    function bet (uint _num) payable public {
        require(_num > 0 && _num <= 5);
        require(msg.value >= minBet);

        uint winNum = random();

        if (_num == winNum) {
            uint amtWon = msg.value * (100 - winRate) / 10;
            (bool sent, ) = payable(msg.sender).call{value:amtWon, gas:1000}("");
            if(!sent){
                revert();
            }
            emit Won(true, amtWon);
        }
        else{
            emit Won(false, 0);
        }
    }

    function getBalance() public view Owned returns (uint) {
        return address(this).balance;
    }

    fallback () external {
        revert();
    }

}