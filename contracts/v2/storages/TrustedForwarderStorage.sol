// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Context variant with ERC2771 support.
 */
contract TrustedForwarderStorage is Ownable {

    event ForwarderAdded(address indexed _address);
    event ForwarderRemoved(address indexed _address);

    mapping (address => bool) private _trustedForwarders;

    function isTrustedForwarder(address _address) external view returns (bool) {
        return _trustedForwarders[_address];
    }

    function addForwarder(address _address) public onlyOwner {
        _trustedForwarders[_address] = true;
        emit ForwarderAdded(_address);
    }

    function removeForwarder(address _address) public onlyOwner {
        _trustedForwarders[_address] = false;
        emit ForwarderRemoved(_address);
    }
}
