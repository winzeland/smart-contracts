// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./LandERC721.sol";
import "../mixins/ContextMixin.sol";

contract LandClaimer is Ownable, ContextMixin {

    address public landContractAddress;
    address public signerAddress;

    using ECDSA for bytes32; 

    constructor(address _landAddress, address _signerAddress) {
        landContractAddress = _landAddress;
        signerAddress = _signerAddress;
    }

    function mint(LandERC721.Properties calldata _properties, bytes calldata _signature) public returns (uint256) {

        bytes memory props = abi.encodePacked(
            _properties.x,
            _properties.y,
            _properties.climate,
            _properties.landType,
            _properties.resource1,
            _properties.resource2,
            _properties.resource3,
            _properties.resource4,
            _properties.resourceLevel1,
            _properties.resourceLevel2,
            _properties.resourceLevel3
        );

        bytes32 _hash = keccak256(props);

        address _signer = _hash.toEthSignedMessageHash().recover(_signature);

        require(_signer == signerAddress, "Signature invalid.");

        LandERC721 _land = LandERC721(landContractAddress);

        return _land.mint(msgSender(), _properties);
    }
}
