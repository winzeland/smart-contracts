// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../mixins/ERC721TradableMixin.sol";

contract LandERC721 is ERC721TradableMixin {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    struct Properties {
        int8 x;
        int8 y;
        uint8 climate;
        uint8 landType;
        uint8 resource1;
        uint8 resource2;
        uint8 resource3;
        uint8 resource4;
        uint8 resourceLevel1;
        uint8 resourceLevel2;
        uint8 resourceLevel3;
        uint8 resourceLevel4;
    }

    event PropertiesUpdated(uint256 indexed _tokenId, Properties _props);

    mapping(uint256 => Properties) public properties;
    // x -> y -> token id
    mapping(int8 => mapping(int8 => uint256)) public coordinates;
    mapping(int8 => mapping(int8 => bool)) public coordinatesTaken;

    string private __baseURI;
    string private __contractURI;

    constructor(address _genesisReceiver, string memory _initBaseURI, string memory _initContractURI) ERC721TradableMixin("Winzeland: Land", "Land") {
        __baseURI = _initBaseURI;
        __contractURI = _initContractURI;
        // Mint genesis land
        Properties memory _properties;
        _properties.landType = 99;
        _properties.resource1 = 1;
        _properties.resource2 = 2;
        _properties.resource3 = 3;
        _properties.resource4 = 4;
        _properties.resourceLevel1 = 10;
        _properties.resourceLevel2 = 10;
        _properties.resourceLevel3 = 10;
        _properties.resourceLevel4 = 10;
        _setProperties(0, _properties);
        _mint(_genesisReceiver, 0);
    }

    function mint(address player, Properties memory _properties)
        public onlyRole(MINTER_ROLE)
        returns (uint256) 
    {
        require(coordinatesTaken[_properties.x][_properties.y] == false, "Land: already minted.");

        uint256 newItemId = totalSupply();

        _setProperties(newItemId, _properties);
        _mint(player, newItemId);

        return newItemId;
    }

    function _setProperties(uint256 _tokenId, Properties memory _properties) internal {
        coordinatesTaken[_properties.x][_properties.y] = true;
        coordinates[_properties.x][_properties.y] = _tokenId;

        properties[_tokenId] = _properties;

        emit PropertiesUpdated(_tokenId, _properties);
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
