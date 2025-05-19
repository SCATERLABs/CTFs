//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Force} from "src/level7.sol";
import {ForceDestruct} from "src/level7.sol";

import {Test, console} from "forge-std/Test.sol";

contract level7Test is Test {
    Force public force;
    ForceDestruct public forceDestruct;
    address public attacker = makeAddr("attacker");
    address public player = makeAddr("player");

    constructor() {
        vm.deal(attacker, 10 ether);
        vm.deal(player, 10 ether);
        vm.startPrank(player);
        force = new Force();
        vm.stopPrank();
    }

    function test_attack() public {
        //here self desruct the contract and send the ether to the force contract
        vm.startPrank(attacker);
        forceDestruct = new ForceDestruct();
        forceDestruct.attack{value: 1 ether}(payable(address(force)));
        assertEq(
            address(force).balance,
            1 ether,
            "Force contract should be destroyed"
        );
        vm.stopPrank();
    }
}
