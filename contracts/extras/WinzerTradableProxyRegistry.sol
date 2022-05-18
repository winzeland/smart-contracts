// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title WinzerTradableProxyRegistry
 * Approves marketplace contract (opensea) for gassless transactions.
 */
contract WinzerTradableProxyRegistry is Ownable {
    address private _operator;

    event OperatorChanged(address _old, address _new);

    function setOperator(address _address) public onlyOwner {
        emit OperatorChanged(_operator, _address);
        _operator = _address;
    }

    function proxies(address _user) public view returns (address) {
        return _operator;
    }
}
