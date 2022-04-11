// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../ERC721Tradable.sol";

contract ERC721Character is ERC721Tradable {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    struct DNA {
        uint8 race;
        uint8 sex;
        // special skill id
        uint8 skill;
        uint8 hair;
        uint8 beard;
        // skin color
        uint8 skin;
        // face details (scars, face paint, frecles)
        uint8 face;
        uint8 eyes;
        uint8 mouth;
    }

    event DnaUpdated(uint256 indexed _tokenId, DNA _dna);

    mapping(uint256 => DNA) public dna;

    string private __baseURI = "https://www.yonder.network/meta/character/";

    constructor() ERC721Tradable("Yonderer Test", "Yonderer") {}

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

    function _baseURI() internal view override returns (string memory) {
        return __baseURI;
    }

    function setBaseUri(string memory uri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        __baseURI = uri;
    }
}
