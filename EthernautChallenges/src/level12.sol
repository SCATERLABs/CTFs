// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor; //True=>flase(accepted)=>again calling(True)
            top = building.isLastFloor(floor);
        }
    }
}
