// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MagicAnimal {
    //    error AnimalNameTooLong();
    mapping(uint256 crateId => uint256 animalInside) public carousel;

    constructor() {
        carousel[0] ^= 1 << 160;
    }

    function Enterstring(
        string memory animalName
    ) public pure returns (uint256) {
        require(bytes(animalName).length <= 12, "ANimal tool long");
        return uint256(bytes32(abi.encodePacked(animalName)) >> 176);
    }

    function dummyEnterString(
        string memory animalName
    ) public pure returns (uint256) {
        require(bytes(animalName).length <= 12, "Animal too long");
        return uint256(bytes32(abi.encodePacked(animalName)));
    }

    function NextCreateId() public pure returns (uint16) {
        return ((type(uint16).max) << 160);
    }

    function printcarousel() public view returns (uint256) {
        return carousel[0];
    }

    function createId(uint256 number) public view returns (uint256) {
        return (carousel[number] & NextCreateId()) >> 160;
    }

    function _addressDecoding(address _addr) public pure returns (uint256) {
        return uint256(uint160(_addr));
    }

    function _addrEncoding(uint256 _addnum) public pure returns (address) {
        return address(uint160(_addnum));
    }
}
