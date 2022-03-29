//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../PennyERC20.sol";
import "../resources/ResourcesERC1155.sol";

/**
 * @dev Contract is responsable of minting and burning our Penny tokens.
 * 
 * For minting, it takes gold bar from user and gives penny tokens.
 * For burning, it takes pennies and gives back gold bars.
 * 
 * Minting and burning will collect fees too.
 */
contract CoinageLaws is Ownable {
    // who collects fees for minting and burning coins (governance / kingdom treasury)
    address public feeCollector;
    // erc-20 token (penny token)
    PennyERC20 public token;
    // erc-1155 token (resources)
    ResourcesERC1155 public resources;
    // resource token id (gold bar)
    uint256 public resourceId = 0;
    // how much one gold bar is worth in pennies.
    // in medieval times gold coin weighted ~3.5g, so lets say our gold bar is 1kg, which makes allows us to mint 285 coins.
    //   should be dynamic and adjusted by how much gold bars and pennies are in circulation?
    uint256 public goldBarInPennies = 285 ether;
    // minimum amount paid by user to mint / burn coins
    uint256 public fixedMintingFee = 2 ether;
    uint256 public fixedBurningFee = 2 ether;
    // dynamic fee paid from minted / burned coins (10_000 = 100%, 100 = 1%, 50 = 0.5%)
    uint16 public dynamicMintingFee = 50;
    uint16 public dynamicBurningFee = 50;

    constructor(address _token, address _resources, uint256 _tokenId) {
        token = PennyERC20(_token);
        resources = ResourcesERC1155(_resources);
        resourceId = _tokenId;
    }
}
