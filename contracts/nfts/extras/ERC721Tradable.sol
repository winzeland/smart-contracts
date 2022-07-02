// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

/**
 * @title ERC721TradableMixin
 * ERC721TradableMixin - ERC721 contract that whitelists a trading address
 */
abstract contract ERC721TradableMixin is ERC721Enumerable, AccessControlEnumerable, ContextMixin {
    address public proxyRegistryAddress;

    event ProxyRegistryAddressChanged(address indexed _newAddress);

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
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

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, AccessControlEnumerable) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId
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
