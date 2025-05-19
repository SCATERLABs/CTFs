// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MagicNum {
    address public solver;

    constructor() {}

    function setSolver(address _solver) public {
        solver = _solver;
    }
}
