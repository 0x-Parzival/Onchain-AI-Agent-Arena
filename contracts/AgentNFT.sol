// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AgentNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Struct to store agent skill scores
    struct AgentSkills {
        uint256 attack;
        uint256 defense;
        uint256 speed;
    }

    // Mapping from token ID to AgentSkills
    mapping(uint256 => AgentSkills) public agentSkills;

    constructor() ERC721("AI Agent NFT", "AGENT") Ownable(initialOwner()) {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://"; // Placeholder, will be configured later
    }

    function safeMint(address to, string memory uri, AgentSkills memory skills) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        agentSkills[tokenId] = skills;
    }

    // OwnableUpgradeable requires initialOwner to be implemented
    function initialOwner() internal view returns (address) {
        return msg.sender;
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
