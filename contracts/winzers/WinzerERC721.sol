// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../mixins/ERC721TradableMixin.sol";

contract WinzerERC721 is ERC721TradableMixin {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    struct DNA1 {
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

    struct DNA2 {
        uint256 father;
        uint256 mother;
        uint8 accessory;
        uint8 makeup;
        uint8 skill1;
        uint8 skill2;
        uint8 skill3;
        uint8 skill4;
        uint8 skill5;
    }

    event Dna1Updated(uint256 indexed _tokenId, DNA1 _dna);
    event Dna2Updated(uint256 indexed _tokenId, DNA2 _dna);

    mapping(uint256 => DNA1) public dna1;
    mapping(uint256 => DNA2) public dna2;

    string private __baseURI;
    string private __contractURI;

    constructor(address _fatherReceiver, string memory _initBaseURI, string memory _initContractURI) ERC721TradableMixin("Winzeland: Winzer", "Winzer") {
        __baseURI = _initBaseURI;
        __contractURI = _initContractURI;
        // minting "AllFather" as first winzer with all zero traits.
        DNA1 memory _dna1;
        DNA2 memory _dna2;
        _mint(_fatherReceiver, 0);
        _setDna1(0, _dna1);
        _setExtraDna(0, _dna2);
    }

    function mint(address player, DNA1 memory _dna1, DNA2 memory _dna2)
        public onlyRole(MINTER_ROLE)
        returns (uint256) 
    {
        uint256 newItemId = totalSupply();
        _mint(player, newItemId);

        _setDna1(newItemId, _dna1);
        _setExtraDna(newItemId, _dna2);

        return newItemId;
    }

    function _setDna1(uint256 _tokenId, DNA1 memory _dna) internal {
        dna1[_tokenId] = _dna;
        emit Dna1Updated(_tokenId, _dna);
    }

    function _setExtraDna(uint256 _tokenId, DNA2 memory _dna) internal {
        dna2[_tokenId] = _dna;
        emit Dna2Updated(_tokenId, _dna);
    }

    function _baseURI() internal view override returns (string memory) {
        return __baseURI;
    }

    function setBaseUri(string memory uri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        __baseURI = uri;
    }

    function contractURI() public view returns (string memory) {
        return __contractURI;
    }

    function setContractURI(string memory uri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        __contractURI = uri;
    }
}
