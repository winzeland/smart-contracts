//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ResourcesERC1155 is ERC1155, AccessControlEnumerable {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");

    constructor() ERC1155("https://www.winzeland.com/meta/resources/{id}") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _mint(_msgSender(), 1, 10, "");
        _mint(_msgSender(), 2, 15, "");
        _mint(_msgSender(), 3, 15000, "");
    }

    function contractURI() public pure returns (string memory) {
        return "https://www.winzeland.com/meta/contract/resources";
    }

    function create(string memory _name, uint256 _decimals) public onlyRole(CREATOR_ROLE) {
        //
    }

    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) public onlyRole(MINTER_ROLE) {
        _mint(to, id, amount, "");
    }

    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public onlyRole(BURNER_ROLE) {
        _burn(account, id, value);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControlEnumerable) returns (bool) {
        return interfaceId == type(IERC1155).interfaceId
         || interfaceId == type(IAccessControlEnumerable).interfaceId
         || super.supportsInterface(interfaceId);
    }
}
