// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract CallMeBack {

    mapping(address => uint256) public balances;

    function donate() public payable {
        balances[msg.sender] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool success,) = msg.sender.call{value: _amount}("");
            require(success, "ETH transfer failed");
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}