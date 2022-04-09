// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract YonderCharacter is ERC721Enumerable, AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    struct DNA {
        uint16 race;
        uint16 sex;
        // special skill id
        uint16 skill;
        uint16 hair;
        uint16 beard;
        // skin color
        uint16 skin;
        // face details (scars, face paint, frecles)
        uint16 face;
        uint16 eyes;
        uint16 mouth;
    }

    event DnaUpdated(uint256 indexed _tokenId, DNA _dna);

    mapping(uint256 => DNA) public dna;

    constructor() ERC721("Yonder", "Yonder") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function mint(address player, DNA memory _dna)
        public onlyRole(MINTER_ROLE)
        returns (uint256) 
    {
        uint256 newItemId = totalSupply();
        _mint(player, newItemId);

        _setDna(newItemId, _dna);

        return newItemId;
    }

    function _setDna(uint256 _tokenId, DNA memory _dna) internal {
        dna[_tokenId] = _dna;
        emit DnaUpdated(_tokenId, _dna);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, AccessControl) returns (bool) {
        return interfaceId == type(ERC721Enumerable).interfaceId || interfaceId == type(AccessControl).interfaceId || super.supportsInterface(interfaceId);
    }
}
