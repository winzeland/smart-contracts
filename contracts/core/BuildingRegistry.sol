//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../ProtocolSettings.sol";

contract BuildingRegistry is Ownable {

    using EnumerableSet for EnumerableSet.AddressSet;

    ProtocolSettings public settings;

    struct BuildingData {
        address owner;
        address building;
    }

    mapping (uint256 => uint256[10]) public landIndexToBuildings;
    mapping (uint256 => BuildingData) public buildingIndexToData;
    mapping (uint256 => address) public indexToOwner;
}
