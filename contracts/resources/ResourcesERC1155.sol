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
        uint8 itemType;
    }

    event ResourceRegistered(uint256 _id, Metadata _metadata);

    uint256 public tokenCount;
    mapping(uint256 => Metadata) public items;
    mapping(uint256 => bool) public registeredItems;

    string private __contractURI;

    constructor(string memory _uri, string memory _initContractURI) ERC1155TradableMixin(_uri) {
        __contractURI = _initContractURI;
    }

    function create(Metadata calldata _metadata) public onlyRole(CREATOR_ROLE) returns (uint256) {
        uint256 id = tokenCount;
        tokenCount = tokenCount + 1;

        items[id] = _metadata;
        _mint(_msgSender(), id, 0, "");

        emit ResourceRegistered(id, _metadata);

        return id;
    }

    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) public onlyRole(MINTER_ROLE) {
        require(registeredItems[id], "resource is not registered.");
        _mint(to, id, amount, "");
    }

    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public onlyRole(BURNER_ROLE) {
        _burn(account, id, value);
    }

    function contractURI() public view returns (string memory) {
        return __contractURI;
    }

    function setContractURI(string memory uri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        __contractURI = uri;
    }
}
