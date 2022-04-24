//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @dev Primary currency of Polygon Kingdom.
 * It can be minted by users in exchange of gold bars, it also can be burned to get gold bars smelted back.
 * Both minting and burning costs fees decided by governance.
 * 
 * CoinEngraver contract is supposed to be sole role owner of MINTER_ROLE and BURNER_ROLE, thus beeing an only minter / burner.
 * Governance can decide to remove or add additional roles.
 * 
 * DEFAULT_ADMIN_ROLE   - governance, can add and remove new minters and burners
 * MINTER_ROLE          - CoinEngraver, takes gold bars and gives coins for a fee
 * BURNER_ROLE          - CoinEngraver, takes coins and gives gold bars for a fee
 */
contract GubbinsERC20 is ERC20, AccessControl {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("Gubbins", "GBN") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /**
    * @dev mint new tokens
    */
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    /**
     * @dev burns tokens out of wallet
     * burner can only burn tokens it owns or has access to allowance to it.
     */
    function burnFrom(address from, uint256 amount) public onlyRole(BURNER_ROLE) {
        _spendAllowance(from, _msgSender(), amount);
        _burn(from, amount);
    }
}
