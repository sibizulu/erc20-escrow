// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract BondNft is ERC721, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    mapping (uint256 => string) private _tokenURIs;

    constructor() ERC721("Bond Sample", "BOND") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Nfttoken: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    function safeMint(address to, uint256 tokenId, string memory _tokenURI) public onlyRole(MINTER_ROLE) {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
    }

    function isOwner(uint __tokenId) public view virtual returns (bool) {
      address owner = ownerOf(__tokenId);
      return msg.sender != owner;
    }

    function burn(uint tokenId) public {
      require(isOwner(tokenId), "No ownership");
      require(_exists(tokenId), "ERC721: approved query for nonexistent token");
      _burn(tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
