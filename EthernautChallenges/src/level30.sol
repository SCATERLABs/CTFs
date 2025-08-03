// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
pragma experimental ABIEncoderV2;

contract HigherOrder {
    address public commander;

    uint256 public treasury;

    function registerTreasury(uint8) public {
        //here in the argument uint8 but in the abi u can take upto 32 bytes
        assembly {
            sstore(treasury.slot, calldataload(4)) //upto 4 offset,take upto 32 bytes
        }
    }

    function claimLeadership() public {
        if (treasury > 255)
            commander = msg.sender; // treasury greater than the 255 accepted
        else revert("Only members of the Higher Order can become Commander");
    }
}
