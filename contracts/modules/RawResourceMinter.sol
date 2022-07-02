//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { LandERC721 } from "../lands/LandERC721.sol";
import { WinzerERC721 } from "../winzers/WinzerERC721.sol";
import { ResourcesERC1155 } from "../resources/ResourcesERC1155.sol";

contract RawResourceMinter is Ownable {

    using SafeMath for uint256;

    struct Works {
        uint256 winzerId;
        uint256 landId;
        // @dev 0 = resource1, 1 = resource2, 2 = resource3, 3 = resource4
        uint8 landZone;
        // @dev timestamp of when winzer started work
        uint256 startedAt;
        // @dev timestamp of when owner claimed resources last time
        uint256 claimedAt;
        bool enabled;
        address owner;
    }

    struct ResourceData {
        // @dev land resource deposit id to raw resource id
        uint256 resourceID;
        // @dev land resource deposit id to time in seconds required to mint one resource
        uint256 requiredTime;
    }

    event WorkStarted(bytes32 indexed _zone, Works _work);
    event WorkStoped(bytes32 indexed _zone);
    event ResourcesClaimed(bytes32 indexed _zone, uint256 _resourceId, uint256 _amount);
    event ResourceDataUpdated(uint8 indexed _depositId, ResourceData _data);

    mapping(bytes32 => Works) public workspace;
    mapping(uint8 => ResourceData) public resources;

    LandERC721 public landContract;
    WinzerERC721 public winzerContract;
    ResourcesERC1155 public resourceContract;

    constructor (address _land, address _winzer, address _resource) {
        landContract = LandERC721(_land);
        winzerContract = WinzerERC721(_winzer);
        resourceContract = ResourcesERC1155(_resource);
    }

    function updateResourceData(uint8 _depositId, ResourceData calldata _data) public onlyOwner {
        resources[_depositId] = _data;
        emit ResourceDataUpdated(_depositId, _data);
    }

    function assign(uint256 _winzerId, uint256 _landId, uint8 _landZone) public returns (bytes32) {
        bytes32 zone = keccak256(abi.encode(_landId, _landZone));
        (uint8 resource,) = getResource(_landId, _landZone);
        require(resource != 0, "land has no resource.");
        require(workspace[zone].startedAt == 0, "Already working.");
        require(winzerContract.ownerOf(_winzerId) == _msgSender(), "You must be owner of winzer.");
        require(landContract.ownerOf(_landId) == _msgSender(), "You must be owner of land.");

        winzerContract.safeTransferFrom(_msgSender(), address(this), _winzerId);

        Works memory _work;
        _work.owner = _msgSender();
        _work.winzerId = _winzerId;
        _work.landId = _landId;
        _work.landZone = _landZone;
        _work.startedAt = block.timestamp;
        _work.claimedAt = block.timestamp;

        workspace[zone] = _work;

        emit WorkStarted(zone, _work);

        return zone;
    }

    function stop(bytes32 _zone) public {
        claim(_zone);

        workspace[_zone].startedAt = 0;
        workspace[_zone].enabled = false;

        emit WorkStoped(_zone);

        landContract.safeTransferFrom(address(this), workspace[_zone].owner, workspace[_zone].winzerId);
    }

    function claim(bytes32 _zone) public {
        Works memory work = workspace[_zone];
        require(work.startedAt != 0);
        require(work.owner == _msgSender());

        (uint8 resource, uint8 level) = getResource(work.landId, work.landZone);

        require(resource != 0, "land has no resource.");

        uint256 amount = calculateAmount(work.claimedAt, block.timestamp, resources[resource].requiredTime);

        if (amount > 0) {
            work.claimedAt = block.timestamp;
            resourceContract.mint(work.owner, resources[resource].resourceID, amount);
        }

        emit ResourcesClaimed(_zone, resource, amount);
    }

    function calculateAmount(uint256 _start, uint256 _end, uint256 _time) public pure returns (uint256) {
        uint256 diff = _end - _start;
        return diff / _time;
    }

    function getResource(uint256 _landId, uint256 _landZone) public view returns (uint8, uint8) {
        (,,,, uint8 resource1, uint8 resource2, uint8 resource3, uint8 resource4, uint8 resourceLevel1, uint8 resourceLevel2, uint8 resourceLevel3) = landContract.properties(_landId);
        if (_landZone == 0) {
            return (resource1, resourceLevel1);
        } else if (_landZone == 1) {
           return (resource1, resourceLevel2); 
        } else if (_landZone == 2) {
           return (resource3, resourceLevel3); 
        } else if (_landZone == 3) {
           return (resource4, resourceLevel3); 
        }
        return (0, 0);
    }
}
