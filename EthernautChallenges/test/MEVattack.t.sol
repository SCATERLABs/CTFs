// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {FrontRan} from "../src/MEVattack.sol";
import {SecureWithdraw} from "../src/MEVattack.sol";

contract MEVTest is Test {
    FrontRan public frontRan;
    SecureWithdraw public secureWithdraw;
    address public attacker;
    address public user;
    bytes32 public secretHash;
    string public password = "supersecret";

    function setUp() public {
        attacker = vm.addr(1);
        user = vm.addr(2);
        secretHash = keccak256(abi.encodePacked(password));

        // Deploy both contracts
        frontRan = new FrontRan{value: 1 ether}(secretHash);
        secureWithdraw = new SecureWithdraw{value: 1 ether}(secretHash);
    }

    function testFrontRanVulnerable() public {
        // Attacker front-runs and calls withdraw first
        vm.prank(attacker);
        frontRan.withdraw(password);

        // Simulate the victim's original withdrawal attempt
        vm.prank(user);
        vm.expectRevert(); // Victim should fail because balance is 0
        frontRan.withdraw(password);

        // Verify attacker stole the funds
        assertEq(attacker.balance, 1 ether, "Attacker stole the funds");
        assertEq(address(frontRan).balance, 0, "Contract should be empty");
    }

    function testSecureWithdrawPreventsMEV() public {
        // Victim commits first
        vm.prank(user);
        secureWithdraw.commit();

        // Attacker attempts to front-run (but never committed)
        vm.prank(attacker);
        vm.expectRevert(SecureWithdraw.NotCommitted.selector);
        secureWithdraw.withdraw(password);

        // Only the legitimate user can withdraw
        vm.prank(user);
        secureWithdraw.withdraw(password);

        // Check that user received the funds, and attacker got nothing
        assertEq(user.balance, 1 ether, "User should receive funds");
        assertEq(attacker.balance, 0, "Attacker should not receive funds");
    }
}
