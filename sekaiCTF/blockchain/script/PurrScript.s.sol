// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

contract PurrScript is Script {
    function run() external {
        // Build JSON params for eth_sendTransaction
        string memory params = string.concat(
            "[{",
                '"from":"', vm.toString(vm.addr(vm.envUint("PRIVATE_KEY"))), '",',
                '"to":"0x6Be13A4a0643C1C2568E980EBC27719f217c185d",', // replace with CAT contract
                '"gas":"0x5208",',        // 21000 gas
                '"value":"0x0",',
                '"type":"0x4b"',          // custom tx type (the key to challenge)
            "}]"
        );

        // Send the transaction using RPC
        bytes memory resp = vm.rpc("eth_sendTransaction", params);

        console2.log("Raw RPC response:");
        console2.logBytes(resp);
    }
}
