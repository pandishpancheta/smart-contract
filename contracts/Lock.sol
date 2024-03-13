// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StockImageNFT is ERC721, Ownable {
    
    constructor(address initialOwner)
        ERC721("StockImageNFT", "SIMG")
        Ownable(initialOwner)
    {}

    struct Item {
        address owner;
        string tokenURI;
        uint256 priceInWei;
    }

    uint256 private _tokenIdCounter;

    mapping (uint256 => string) private _tokenURIs;
    mapping(bytes32 => Item) private items;

    string private _baseURIextended = "https://emerald-efficient-caterpillar-983.mypinata.cloud/ipfs/";

    function setBaseURI(string memory baseURI_) external onlyOwner() {
        _baseURIextended = baseURI_;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_ownerOf(tokenId) != address(0), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();
        
        if (bytes(base).length == 0) {
            return _tokenURI;
        }

        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return string(abi.encodePacked(base, tokenId));
    }