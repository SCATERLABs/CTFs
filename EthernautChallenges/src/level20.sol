// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";

contract AlienCodex is Ownable {
    constructor() Ownable(msg.sender) {}

    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    // function retract() public contacted {
    //     // delete codex[codex.length - 1];

    //     assembly {
    //         sstore(codex.slot, sub(sload(codex.slot), 1))
    //     }
    // }
    function retract() public contacted {
        assembly {
            // codex.slot is the storage slot where the array's length is stored.
            let p := codex.slot
            // Subtract 1 from the stored length, which is unsafe and causes underflow.
            sstore(p, sub(sload(p), 1))
        }
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}
