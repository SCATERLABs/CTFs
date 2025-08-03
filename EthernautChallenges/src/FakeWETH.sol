// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FakeWETH {
    function transferFrom(
        address,
        address,
        uint256
    ) external pure returns (bool) {
        return true;
    }

    function allowance(address, address) external pure returns (uint256) {
        return type(uint256).max;
    }
}
