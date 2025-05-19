// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Test.sol";
import "../lib/forge-std/src/console.sol";
import "../src/impersanator.sol";

contract ECLockerTest is Test {
    Impersonator public impersonator;
    ECLocker public locker;
    address public owner = vm.addr(1);
    uint256 public lockId = 1;
    bytes public signature;

    function setUp() public {
        vm.startPrank(owner);
        impersonator = new Impersonator(lockId);
        vm.stopPrank();
    }

    function testSignatureMalleability() public {
        vm.startPrank(owner);

        // Generate a valid signature for testing
        (uint8 v, bytes32 r, bytes32 s) = generateValidSignature(lockId);
        signature = abi.encodePacked(r, s, v);

        // Deploy locker
        impersonator.deployNewLock(signature);
        locker = impersonator.lockers(0);

        // Modify signature (malleability attack)
        bytes32 sPrime = bytes32(
            uint256(
                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
            ) - uint256(s)
        );
        uint8 vPrime = (v == 27) ? 28 : 27;

        // Change controller using malleable signature
        locker.changeController(vPrime, r, sPrime, address(0));

        // Verify controller is now address(0)
        assertEq(
            locker.controller(),
            address(0),
            "Controller takeover via signature malleability failed"
        );
    }

    function testDuplicateSignatureRejection() public {
        vm.startPrank(owner);

        (uint8 v, bytes32 r, bytes32 s) = generateValidSignature(lockId);
        signature = abi.encodePacked(r, s, v);

        impersonator.deployNewLock(signature);
        locker = impersonator.lockers(0);

        // First valid use
        locker.open(v, r, s);

        // Try reusing the same signature
        vm.expectRevert(ECLocker.SignatureAlreadyUsed.selector);
        locker.open(v, r, s);
    }

    function testUnauthorizedControllerChange() public {
        vm.startPrank(owner);

        (uint8 v, bytes32 r, bytes32 s) = generateValidSignature(lockId);
        signature = abi.encodePacked(r, s, v);

        impersonator.deployNewLock(signature);
        locker = impersonator.lockers(0);

        // Attempt unauthorized controller change
        vm.expectRevert(ECLocker.InvalidController.selector);
        locker.changeController(v, r, s, vm.addr(2));
    }

    function generateValidSignature(
        uint256 _lockId
    ) internal pure returns (uint8, bytes32, bytes32) {
        bytes32 hash = keccak256(abi.encodePacked(_lockId));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, hash); //using vm.sign to use this to get the data in the v,r,s
        return (v, r, s);
    }
}
