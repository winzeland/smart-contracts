// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "../extras/TradableProxyRegistry.sol";
import "./ContextMixin.sol";

/**
 * @title ERC1155TradableMixin
 * ERC1151TradableMixin - ERC1151 contract that whitelists a trading address
 */
abstract contract ERC1155TradableMixin is ERC1155Supply, AccessControlEnumerable, ContextMixin {
    address public proxyRegistryAddress;

    event ProxyRegistryAddressChanged(address indexed _newAddress);

    constructor(
        string memory uri_
    ) ERC1155(uri_) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /**
     * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
     */
    function isApprovedForAll(address _owner, address _operator)
        override
        public
        view
        returns (bool)
    {
        // Whitelist OpenSea proxy contract for easy trading.
        TradableProxyRegistry proxyRegistry = TradableProxyRegistry(proxyRegistryAddress);
        if (proxyRegistry.whitelistedOperators(_operator)) {
            return true;
        }

        return super.isApprovedForAll(_owner, _operator);
    }

    function setProxyRegistryAddress(address _proxyRegistryAddress) public onlyRole(DEFAULT_ADMIN_ROLE) {
        proxyRegistryAddress = _proxyRegistryAddress;
        emit ProxyRegistryAddressChanged(_proxyRegistryAddress);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControlEnumerable) returns (bool) {
        return interfaceId == type(ERC1155Supply).interfaceId
         || interfaceId == type(IAccessControlEnumerable).interfaceId
         || super.supportsInterface(interfaceId);
    }

    function owner() public view returns (address) {
        return getRoleMember(DEFAULT_ADMIN_ROLE, 0);
    }

    function _msgSender()
        internal
        override
        view
        returns (address sender)
    {
        return msgSender();
    }
}
