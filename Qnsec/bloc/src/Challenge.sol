// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "src/CallMeBack.sol";

contract Challenge {
    address public immutable PLAYER;
    CallMeBack public immutable CONTRACT;

    bool private solved;

    constructor(address player, address _contract) public {
        PLAYER = player;
        
        CONTRACT = CallMeBack(payable(_contract));
    }

    function solve() external {
        require(address(PLAYER).balance > 10 ether, "NOT_ENOUGH_ETHER");
        solved = true;
    }

    function isSolved() external view returns (bool) {
        return solved;
    }
}
