//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Instance} from "../src/level1.sol";

import {Test, console} from "forge-std/Test.sol";

contract Level1Test is Test {
    Instance public instance;
    address public player;
    address public attacker;
    string public password = "hello";

    function setUp() public {
        player = address(0x123);
        attacker = address(0x456);
        vm.deal(player, 10 ether); // Give player some ETH
        vm.deal(attacker, 10 ether); // Give attacker some ETH
        vm.startPrank(player);
        instance = new Instance(password);
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker);

        string memory result = instance.info();
        assertEq(
            result,
            "You will find what you need in info1().",
            "info failed"
        );
        result = instance.info1();
        assertEq(
            result,
            'Try info2(), but with "hello" as a parameter.',
            "info1 failed"
        );

        // Call info2
        result = instance.info2("hello");
        assertEq(
            result,
            "The property infoNum holds the number of the next info method to call.",
            "info2 failed"
        );

        result = instance.info42();
        assertEq(
            result,
            "theMethodName is the name of the next method.",
            "info42 failed"
        );

        result = instance.method7123949();
        assertEq(
            result,
            "If you know the password, submit it to authenticate().",
            "method7123949 failed"
        );

        // Call authenticate
        instance.authenticate(password);

        // Check if cleared
        bool cleared = instance.getCleared();
        assertTrue(cleared, "Authentication failed");
    }

    function test_pass_attack() public {
        vm.startPrank(attacker);
        //get the password
        string memory resultpass = instance.password(); //storing it as a public variable
        assertEq(resultpass, password, "password failed");
    }
}
