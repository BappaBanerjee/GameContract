// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract WelcomeKit is ERC721, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

   string[] ipfsUri=[
        "QmdCYvCyVJjuLzJpPLaCMUSEb6UD83ETBwH4uaCUKjy3oi/ball_metadata.json",
        "QmdCYvCyVJjuLzJpPLaCMUSEb6UD83ETBwH4uaCUKjy3oi/bat_metadata.json",
        "QmdCYvCyVJjuLzJpPLaCMUSEb6UD83ETBwH4uaCUKjy3oi/shoe_metadata.json",
        "QmUQTfYygw5p8DuZojvdj58Wi4QqvURy3K1kfqk61bjYET"
    ];

    constructor() ERC721("WelcomeKit", "Kit") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) internal returns (uint256[] memory){
        uint256[] memory newTokenIds = new uint256[](ipfsUri.length);
        for (uint i = 0; i < ipfsUri.length; i++) {
            uint256 newTokenId = _tokenIdCounter.current();
            _safeMint(to, newTokenId);
            _setTokenURI(newTokenId, ipfsUri[i]);
            newTokenIds[i] = newTokenId;
            _tokenIdCounter.increment();
        }
        return newTokenIds;
    }
    

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override
    {
        require(from == address(0) || to == address(0), "This a Soulbound token. It cannot be transferred. It can only be burned by the token owner.");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}