// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../ERC721Tradable.sol";

contract LandERC721 is ERC721Tradable {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    struct DNA {
        uint8 x;
        uint8 y;
        uint8 climate;
        uint8 landType;
        uint8 resource1;
        uint8 resource2;
        uint8 resource3;
        uint8 resourceLevel1;
        uint8 resourceLevel2;
        uint8 resourceLevel3;
    }

    event DnaUpdated(uint256 indexed _tokenId, DNA _dna);

    mapping(uint256 => DNA) public dna;
    // x -> y -> token id
    mapping(uint8 => mapping(uint8 => uint256)) public coordinates;
    mapping(uint8 => mapping(uint8 => bool)) public coordinatesTaken;

    string private __baseURI = "https://www.winzeland.network/meta/land/";

    constructor() ERC721Tradable("Winzeland: Land", "Land") {}

    function mint(address player, DNA memory _dna)
        public onlyRole(MINTER_ROLE)
        returns (uint256) 
    {
        require(coordinatesTaken[_dna.x][_dna.y] == false, "Land: already minted.");

        uint256 newItemId = totalSupply();
        _mint(player, newItemId);

        _setDna(newItemId, _dna);

        return newItemId;
    }

    function _setDna(uint256 _tokenId, DNA memory _dna) internal {

        coordinates[_dna.x][_dna.y] = _tokenId;
        coordinatesTaken[_dna.x][_dna.y] = true;

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
