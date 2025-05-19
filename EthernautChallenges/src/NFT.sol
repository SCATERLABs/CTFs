// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    constructor() ERC721("Scater", "SCTR") Ownable(msg.sender) {}

    function mint(address to, string memory metadataURI) public onlyOwner {
        _safeMint(to, _nextTokenId);
        _setTokenURI(_nextTokenId, metadataURI);
        _nextTokenId++;
    }
}
