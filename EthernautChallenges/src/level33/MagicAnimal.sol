// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MagicAnimalCarousel {
    uint16 public constant MAX_CAPACITY = type(uint16).max;
    ////(80 bits for animal name +16 bits for next crate ID + 160 bits for ownner address))
    uint256 constant ANIMAL_MASK = uint256(type(uint80).max) << (160 + 16); //176-256 bits
    uint256 public constant NEXT_ID_MASK = uint256(type(uint16).max) << 160; //16 bits
    uint256 constant OWNER_MASK = uint256(type(uint160).max); //160 bits for storing owner address

    uint256 public currentCrateId;
    mapping(uint256 => uint256) public carousel;

    // error AnimalNameTooLong();

    constructor() {
        carousel[0] ^= 1 << 160; //160 bit is 1
    }

    function setAnimalAndSpin(string calldata animal) external {
        uint256 encodedAnimal = encodeAnimalName(animal) >> 16; //again shift right by 16 bits to fit in 80 bits
        uint256 nextCrateId = (carousel[currentCrateId] & NEXT_ID_MASK) >> 160;

        require(
            encodedAnimal <= uint256(type(uint80).max),
            // AnimalNameTooLong()
            "Animal name too Long"
        );
        carousel[nextCrateId] =
            ((carousel[nextCrateId] & ~NEXT_ID_MASK) ^
                (encodedAnimal << (160 + 16))) |
            (((nextCrateId + 1) % MAX_CAPACITY) << 160) |
            uint160(msg.sender);

        currentCrateId = nextCrateId;
    }

    function changeAnimal(string calldata animal, uint256 crateId) external {
        address owner = address(uint160(carousel[crateId] & OWNER_MASK));
        if (owner != address(0)) {
            require(msg.sender == owner);
        }
        uint256 encodedAnimal = encodeAnimalName(animal);
        if (encodedAnimal != 0) {
            // Replace animal
            carousel[crateId] =
                (encodedAnimal << 160) |
                (carousel[crateId] & NEXT_ID_MASK) |
                uint160(msg.sender);
        } else {
            // If no animal specified keep same animal but clear owner slot
            carousel[crateId] = (carousel[crateId] &
                (ANIMAL_MASK | NEXT_ID_MASK));
        }
    }

    function encodeAnimalName(
        string calldata animalName
    ) public pure returns (uint256) {
        //@audit here length of animal name is only 10 bytes(80 bits) but in carousel it is 12 bytes(96 bits)
        require(bytes(animalName).length <= 12, "Animal name too long");
        return uint256(keccak256(abi.encodePacked(animalName)) >> 160); //uint256(96bits hashof animal name shifted right by 160 bits to fit in 80 bits  )
    }
}
// The Magic Rule
// The "magic rule" of the carousel is:

// If an animal is added to the carousel, it must remain there unless explicitly changed by the owner.

// In code terms:

// When you call setAnimalAndSpin(animal), the animal should be stored in the carousel.

// If you check the carousel immediately after, the animal should still be there.

// Your goal is to break this rule by making the carousel lose or change an animal unexpectedly.

// Animal Name Length:

//1. The encodeAnimalName function allows animal names up to 12 bytes, but the carousel only has space for 10 bytes.

// This means the last 2 bytes of a 12-byte animal name will overflow into the next crate ID field.

// 2.No Validation in changeAnimal:

// The changeAnimal function does not check the length of the new animal name.

// This allows you to overwrite the next crate ID with the overflowed bytes from a 12-byte animal name.
