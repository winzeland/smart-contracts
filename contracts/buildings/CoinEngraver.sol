//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../laws/CoinageLaws.sol";

/**
 * @dev Contract is responsable of minting and burning our Penny tokens.
 * 
 * For minting, it takes gold bar from user and gives penny tokens.
 * For burning, it takes pennies and gives back gold bars.
 * 
 * Minting and burning will collect fees too.
 */
contract CoinEngraver is Ownable {

    using SafeMath for uint256;

    CoinageLaws public coinageLaws;

    /**
     * @dev send {_sentAmount} of gold bars and receives {amount} of pennies.
     * {amount} returned already excludes {fee} amount which will be sent to kingdoms treasury.
     */
    function getExpectedMintReturn(uint256 _sentAmount) public view returns (uint256 amount, uint256 fee) {
        amount = _sentAmount.mul(coinageLaws.goldBarInPennies());
        fee = amount.mul(coinageLaws.dynamicMintingFee() / 10_000).add(coinageLaws.fixedMintingFee());
        if (fee > 0) {
            amount = amount.sub(fee);
        }
    }

    /**
     * @dev send {_sentAmount} of pennies and receive {amount} gold bars.
     * {fee} of pennies will be deducted from {_sentAmount} before they are being converted to gold bars.
     */
    function getExpectedBurnReturn(uint256 _sentAmount) public view returns (uint256 amount, uint256 fee) {
        fee = _sentAmount.mul(coinageLaws.dynamicBurningFee() / 10_000).add(coinageLaws.fixedBurningFee());

        if (fee >= _sentAmount) {
            amount = 0;
        } else {
            _sentAmount = _sentAmount.sub(fee);
            amount = _sentAmount.div(coinageLaws.goldBarInPennies());
        }
    }

    /**
     * @dev sent gold bars to receive golden pennies.
     */
    function mint(uint256 _sentAmount) public {
        ResourcesERC1155 res = coinageLaws.resources();
        require(res.balanceOf(_msgSender(), coinageLaws.resourceId()) >= _sentAmount, "coiner: no gold bars");

        (uint256 amountToMint, uint256 fee) = getExpectedMintReturn(_sentAmount);

        if (amountToMint > 0) {
            // burn gold bars from user inventory
            coinageLaws.resources().burn(_msgSender(), coinageLaws.resourceId(), _sentAmount);
            // send pennies to user
            coinageLaws.token().mint(_msgSender(), amountToMint);
        }

        if (fee > 0) {
            coinageLaws.token().mint(coinageLaws.feeCollector(), fee);
        }
    }

    /**
     * @dev send pennies to receive gold bars.
     */
    function burn(uint256 _sentAmount) public {
        GubbinsERC20 penny = coinageLaws.token();
        require(penny.balanceOf(_msgSender()) >= _sentAmount, "coiner: no gold bars");

        (uint256 amount, uint256 fee) = getExpectedBurnReturn(_sentAmount);

        if (amount > 0) {
            // send burning fee to treasury
            penny.transferFrom(_msgSender(), coinageLaws.feeCollector(), fee);
            // burn tokens user sent
            penny.burnFrom(_msgSender(), _sentAmount.sub(fee));
            // send gold bars to user
            coinageLaws.resources().mint(_msgSender(), coinageLaws.resourceId(), amount);
        }
    }
}
