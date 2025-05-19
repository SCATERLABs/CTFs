// import "forge-std/Test.sol";
// import "../src/challnge.sol";

// contract ChallengeTest is Test {
//     Challenge challenge;

//     function setUp() public {
//         challenge = new Challenge();
//     }

//     function testValidTx() public {
//         vm.deal(address(this), 1 ether); // Give this contract 1 ether

//         (bool success, ) = address(challenge).call{value: 0.1 ether}(
//             hex"60205f8037346020525f51465f5260405f2054585460205114911416366020141615602157005b5f80fd"
//         );

//         assertTrue(success, "Transaction reverted!");
//     }
// }

// import "forge-std/Test.sol";

// contract TestContract is Test {
//     address contractAddress = 0xa60Fa8391625163b1760f89DAc94bac2C448f897;

//     function testFindValidInputs() public {
//         // Declare and initialize arrays correctly
//         uint256[] memory values = new uint256[](5);
//         bytes[] memory dataInputs = new bytes[](5);
//         values[0] = 0;
//         values[1] = 1;
//         values[2] = 100;
//         values[3] = 1000;
//         values[4] = 10000;

//         dataInputs[0] = hex"";
//         dataInputs[1] = hex"01";
//         dataInputs[2] = hex"abcdef";
//         dataInputs[3] = hex"123456";
//         dataInputs[4] = hex"deadbeef";

//         for (uint256 i = 0; i < values.length; i++) {
//             for (uint256 j = 0; j < dataInputs.length; j++) {
//                 (bool success, ) = payable(contractAddress).call{
//                     value: values[i]
//                 }(dataInputs[j]);

//                 if (success) {
//                     console.log("Valid tx.value and tx.data found!");
//                     console.log("value:", values[i]);
//                     console.logBytes(dataInputs[j]);
//                 }
//             }
//         }
//     }
// }

// import "forge-std/Test.sol";

// contract TestContract is Test {
//     address contractAddress = 0xa60Fa8391625163b1760f89DAc94bac2C448f897;

//     function testFindValidInputs() public {
//         uint256[5] memory values = [uint256(0), 1, 100, 1000, 10000];
//         bytes32[5] memory dataInputs = [
//             bytes32(0),
//             keccak256("test"),
//             keccak256("123456"),
//             keccak256("abcdef"),
//             keccak256("polygon")
//         ];

//         for (uint256 i = 0; i < values.length; i++) {
//             for (uint256 j = 0; j < dataInputs.length; j++) {
//                 (bool success, ) = payable(contractAddress).call{
//                     value: values[i]
//                 }(abi.encodePacked(dataInputs[j]));

//                 if (success) {
//                     console.log("Valid tx.value and tx.data found!");
//                     console.log("value:", values[i]);
//                     console.logBytes(abi.encodePacked(dataInputs[j]));
//                 }
//             }
//         }
//     }
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract ContractTest is Test {
    // Address of the deployed contract on Polygon Amoy Testnet
    address constant CONTRACT_ADDRESS =
        0xa60Fa8391625163b1760f89DAc94bac2C448f897;

    function testTransaction() public {
        // Set the tx.value and tx.data
        uint256 value = 0x1; // 1 wei
        bytes
            memory data = hex"0000000000000000000000000000000000000000000000000000000000000001"; // 32-byte data

        // Send the transaction using low-level call
        (bool success, ) = CONTRACT_ADDRESS.call{value: value}(data);

        // Assert that the transaction did not revert
        assertTrue(success, "Transaction reverted");
    }
}
