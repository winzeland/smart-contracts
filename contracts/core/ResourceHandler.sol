//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @dev Resource Handler is responsible on minting and burning Resource NFTs.
 * User must approve their resources to the handler to be able to play game.
 * 
 * Resource Handler is used by Buildings, when building "creates" new item, resource handler mints it,
 *   when building "uses" an item - handler burns it.
 *
 * Buildings must be added as MINTER and/or BURNER to be able to call Resource handler functions.
 */
contract ResourceHandler is AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function mint(address _to, uint256 _tokenId, uint256 _amount) public {
        //
    }

    function burn(address _from, uint256 _tokenId, uint256 _amount) public {
        //
    }

}
