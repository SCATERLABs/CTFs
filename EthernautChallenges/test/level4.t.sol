//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;
import {CoinFlip} from "../src/level4.sol";
import {CoinFlipAttack} from "../src/level4.sol";
import {Test, console} from "forge-std/Test.sol";

contract CoinFlipTest is Test {
    CoinFlip public coinFlip;
    CoinFlipAttack public coinFlipAttack;
    address public player;
    address public attacker;
    uint256 constant FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function setUp() public {
        player = address(0x344);
        attacker = address(0x457);
        vm.deal(player, 10 ether);
        vm.deal(attacker, 10 ether);
        vm.startPrank(player);
        coinFlip = new CoinFlip();
        coinFlipAttack = new CoinFlipAttack(address(coinFlip));
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker);

        for (uint256 i = 0; i < 10; i++) {
            vm.roll(block.number + 1); //vm.roll is used to increment the block number
            coinFlipAttack.attack();
        }

        assertEq(
            coinFlip.consecutiveWins(),
            10,
            "Attack failed to reach 10 wins"
        );

        vm.stopPrank();
    }
}
