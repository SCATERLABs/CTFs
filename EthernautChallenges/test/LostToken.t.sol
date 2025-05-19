// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Recovery, SimpleToken} from "../src/LostToken.sol"; // Import the Recovery contract

contract RecoveryTest is Test {
    Recovery public recovery;
    address public deployer;
    address public lostContract;
    address public retriever;
    SimpleToken public token;

    function setUp() public {
        deployer = address(this); // This contract acts as the deployer
        retriever = address(0xBEEF); // Set an address to receive recovered ETH
        recovery = new Recovery();
    }

    function testRecoverLostEther() public {
        // 🏗 Step 1: Deploy a SimpleToken contract via generateToken()
        vm.prank(deployer);
        recovery.generateToken("LostToken", 1000);

        // 🔎 Step 2: Compute the lost contract address
        lostContract = computeLostContractAddress(address(recovery), 1);
        console.log("Lost contract address:", lostContract);

        // 💰 Step 3: Simulate sending 0.001 ETH to the lost contract
        vm.deal(deployer, 1 ether); // Give deployer 1 ether
        vm.prank(deployer);
        (bool success, ) = lostContract.call{value: 0.001 ether}("");
        require(success, "Failed to send ETH to lost contract");

        // ✅ Step 4: Ensure the lost contract received the ETH
        assertEq(
            lostContract.balance,
            0.001 ether,
            "Lost contract didn't receive ETH"
        );

        // ⚠ Step 5: Call `destroy()` from the deployer
        vm.prank(deployer); // The deployer of the contract calls `destroy()`
        SimpleToken(payable(lostContract)).destroy(payable(retriever));

        // ✅ Step 6: Verify ETH is recovered
        assertEq(
            retriever.balance,
            0.001 ether,
            "Failed to recover lost ether"
        );
    }

    // Computes the lost contract address using CREATE address calculation
    function computeLostContractAddress(
        address creator,
        uint256 nonce
    ) internal pure returns (address) {
        return
            address(
                uint160(
                    uint(
                        keccak256(
                            abi.encodePacked(
                                bytes1(0xd6),
                                bytes1(0x94),
                                creator,
                                bytes1(uint8(nonce))
                            )
                        )
                    )
                )
            );
    }
}
