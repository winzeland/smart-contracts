// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (metatx/ERC2771Context.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "../../storages/TrustedForwarderStorage.sol";

/**
 * @dev Context variant with ERC2771 support.
 */
abstract contract ERC2771Context is Context {

    event ForwarderRegistryChanged(address _address);

    address private _forwarderRegistry;

    constructor(address _forwarderRegistryAddress) {
        setForwarderRegistry(_forwarderRegistryAddress);
    }

    function setForwarderRegistry(address _address) internal {
        _forwarderRegistry = _address;
        emit ForwarderRegistryChanged(_address);
    }

    function forwarderRegistry() external view returns (address) {
        return _forwarderRegistry;
    }

    function isTrustedForwarder(address forwarder) public view virtual returns (bool) {
        return TrustedForwarderStorage(_forwarderRegistry).isTrustedForwarder(forwarder);
    }

    function _msgSender() internal view virtual override returns (address sender) {
        if (isTrustedForwarder(msg.sender)) {
            // The assembly code is more direct than the Solidity version using `abi.decode`.
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else {
            return super._msgSender();
        }
    }

    function _msgData() internal view virtual override returns (bytes calldata) {
        if (isTrustedForwarder(msg.sender)) {
            return msg.data[:msg.data.length - 20];
        } else {
            return super._msgData();
        }
    }
}
