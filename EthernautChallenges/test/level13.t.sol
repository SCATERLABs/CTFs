//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Privacy} from "../src/level13.sol";
import {Test, console} from "forge-std/Test.sol";

contract PrivacyTest is Test {
    Privacy public privacy;
    bytes32[3] public data;

    function setUp() public {
        data = [bytes32(0), bytes32("hello nithin"), bytes32("hii")];
        privacy = new Privacy(data);
    }

    function test_attack() public {
        //i need to storage vallu of of slot 5
        bytes32 value = vm.load(address(privacy), bytes32(uint256(5)));
        string memory str = string(abi.encodePacked(value));
        console.log("value of slot 5", str);
        privacy.unlock(bytes16(value));
        assertTrue(privacy.locked() == false);
    }
}
