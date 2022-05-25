// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TradableProxyRegistry
 * Approves marketplace contract (opensea) for gassless transactions.
 */
contract TradableProxyRegistry is Ownable {
    mapping(address => bool) public whitelistedOperators;

    event OperatorAdded(address _operator);
    event OperatorRemoved(address _operator);

    function addOperator(address _operator) public onlyOwner {
        whitelistedOperators[_operator] = true;
        emit OperatorAdded(_operator);
    }

    function removeOperator(address _operator) public onlyOwner {
        whitelistedOperators[_operator] = false;
        emit OperatorRemoved(_operator);
    }
}
