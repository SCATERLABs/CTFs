// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {MagicNum} from "../src/level19.sol";
import {Test, console} from "forge-std/Test.sol";

contract MagicNumTest is Test {
    MagicNum public magicnum;
    address public attacker = makeAddr("attacker");
    address public player = makeAddr("player");

    function setUp() public {
        vm.deal(attacker, 100 ether);
        vm.deal(player, 100 ether);
        vm.startPrank(player);
        magicnum = new MagicNum();
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker);
        address solver;
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";

        assembly {
            solver := create(0, add(bytecode, 0x20), 0x13)
        }
        require(solver != address(0), "contract solver deployment failed");
        magicnum.setSolver(solver);
        (bool success, bytes memory data) = solver.staticcall("");
        require(success, "call to solver failed");
        uint256 result = abi.decode(data, (uint256));
        console.log("result: ", result);
        require(result == 42, "solver did not return 42");
        vm.stopPrank();
    }
}
