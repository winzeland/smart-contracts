// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../ERC721Tradable.sol";

contract WinzerERC721 is ERC721Tradable {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    struct DNA {
        uint8 race;
        uint8 sex;
        uint8 skin;
        uint8 head;
        uint8 ears;
        uint8 hair;
        uint8 beard;
        uint8 mouth;
        uint8 eyes;
        uint8 eyebrows;
        uint8 nose;
        uint8 scars;
    }

    struct ExtraDNA {
        uint8 accessory;
        uint8 makeup;
        uint8 skill1;
        uint8 skill2;
        uint8 skill3;
        uint8 skill4;
        uint8 skill5;
    }

    event DnaUpdated(uint256 indexed _tokenId, DNA _dna);
    event ExtraDnaUpdated(uint256 indexed _tokenId, ExtraDNA _dna);

    mapping(uint256 => DNA) public dna;
    mapping(uint256 => ExtraDNA) public extraDna;

    string private __baseURI = "https://www.winzerland.com/meta/character/";

    constructor() ERC721Tradable("Winzerland: Winzer", "Winzer") {}

    function mint(address player, DNA memory _dna, ExtraDNA memory _extraDna)
        public onlyRole(MINTER_ROLE)
        returns (uint256) 
    {
        uint256 newItemId = totalSupply();
        _mint(player, newItemId);

        _setDna(newItemId, _dna);
        _setExtraDna(newItemId, _extraDna);

        return newItemId;
    }

    function _setDna(uint256 _tokenId, DNA memory _dna) internal {
        dna[_tokenId] = _dna;
        emit DnaUpdated(_tokenId, _dna);
    }

    function _setExtraDna(uint256 _tokenId, ExtraDNA memory _dna) internal {
        extraDna[_tokenId] = _dna;
        emit ExtraDnaUpdated(_tokenId, _dna);
    }

    function _baseURI() internal view override returns (string memory) {
        return __baseURI;
    }

    function setBaseUri(string memory uri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        __baseURI = uri;
    }
}
