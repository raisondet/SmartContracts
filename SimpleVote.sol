// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Vote {
    
    // structure
    struct candidator{
        string name;
        uint upVote;
    }
    
    // variable
    bool live;
    address owner;
    candidator[] public candidatorList;
    
    // mapping
    mapping(address => bool) Voted;
    
    // event
    event AddCandidator(string name);
    event UpVote(string candidator, uint upVote);
    event FinishVote(bool live);
    event Voting(address owner);
    
    // modifier
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    // constructor
    constructor() {
        owner = msg.sender;
        live = true;
        
        emit Voting(owner);
    }
    
    // candidator
    function addCandidate(string calldata _name) public {
        require(candidatorList.length < 5);
        candidatorList.push(candidator(_name, 0));
        
        // emit event
        emit AddCandidator(_name);
    }
    
    function upVote(uint _indexOfCandidator) public {
        require(candidatorList.length > _indexOfCandidator);
        require(Voted[msg.sender] == false);
        candidatorList[_indexOfCandidator].upVote++;
        
        Voted[msg.sender] = true;
        
        // emit event
        emit UpVote(candidatorList[_indexOfCandidator].name, candidatorList[_indexOfCandidator].upVote);
    }
    
    function finishVote() public onlyOwner {
        live = false;
        
        emit FinishVote(live);
    }
}