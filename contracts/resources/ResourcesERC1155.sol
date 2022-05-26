//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../mixins/ERC1155TradableMixin.sol";


contract ResourcesERC1155 is ERC1155TradableMixin {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");

    struct Metadata {
        string name;
        uint8 typeId;
        uint8 subtypeId;
    }

    struct Attributes {
        uint8 attr1;
        int8 value1;
        uint8 attr2;
        int8 value2;
        uint8 attr3;
        int8 value3;
        uint8 attr4;
        int8 value4;
        uint8 attr5;
        int8 value5;
        uint8 attr6;
        int8 value6;
    }

    event ResourceRegistered(uint256 _id, Metadata _metadata);
    event AttributesUpdated(uint256 _id, Attributes _attributes);

    mapping(uint256 => Metadata) public metadata;
    mapping(uint256 => Attributes) public attributes;

    mapping(uint256 => bool) private _registered;
    string private __contractURI;

    constructor(string memory _uri, string memory _initContractURI) ERC1155TradableMixin(_uri) {
        __contractURI = _initContractURI;
    }

    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) public onlyRole(MINTER_ROLE) {
        require(_registered[id], "resource is not registered.");
        _mint(to, id, amount, "");
    }

    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public onlyRole(BURNER_ROLE) {
        _burn(account, id, value);
    }

    function registerItem(uint256 _id, Metadata calldata _metadata) public onlyRole(CREATOR_ROLE) returns (uint256) {
        require(!_registered[_id], "resource already registered.");
        metadata[_id] = _metadata;
        _registered[_id] = true;
        _mint(_msgSender(), _id, 0, "");

        emit ResourceRegistered(_id, _metadata);

        return _id;
    }

    function updateAttributes(uint256 _id, Attributes calldata _attributes) public onlyRole(CREATOR_ROLE) {
        require(_registered[_id], "resource is not registered.");
        attributes[_id] = _attributes;
        emit AttributesUpdated(_id, _attributes);
    }

    function registered(uint256 _id) public view returns (bool) {
        return _registered[_id];
    }

    function contractURI() public view returns (string memory) {
        return __contractURI;
    }

    function setContractURI(string memory uri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        __contractURI = uri;
    }
}
