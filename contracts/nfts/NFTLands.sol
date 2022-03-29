//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract NFTConstructionRegistry is Ownable {
    mapping(address => bool) public constructions;
}

/**
 * @dev world is [-50; 50] in size for both x and y directions, so 10201 blocks in total.
 * coordinates between [-5; 5] to both x and y directions are reserved to governance (121 blocks)
 * coordinates between [-8, 8] are reserved to team members (168 blocks)
 * everything further than coordinate 8 is available for minting
 */
contract NFTLands is ERC721Enumerable, Ownable {

    enum ResourceType { NONE, WOOD, STONE, SOIL, IRON, GOLD }
    enum Level { NONE, LOW, MEDIUM, HIGH }

    // total world size 100 x 100 = 10k 
    uint256 public constant WORLD_SIZE = 100;
    // reserve 49 land blocks to governance, [47;53] (50;50) is reserved to town-hall.
    uint256[] public GOVERNANCE_RESERVED = [4949, 4950, 4951, 5049, 5050, 5051, 5149, 5150, 5151]; 
    // coordinates [45;46] and [54;55] are reserved to team (72 blocks)
    uint256 public constant TEAM_RESERVED = 2;

    struct Coordinates {
        uint256 x;
        uint256 y;
    }

    struct LandData {
        ResourceType resourceType1;
        Level resourceLevel1;
        ResourceType resourceType2;
        Level resourceLevel2;
        ResourceType resourceType3;
        Level resourceLevel3;
        ResourceType resourceType4;
        Level resourceLevel4;
        ResourceType resourceType5;
        Level resourceLevel5;
    }

    // x[y] = tokenId
    mapping(uint256 => mapping(uint256 => uint256)) private _lands;
    // x[y] = true / false
    mapping(uint256 => mapping(uint256 => bool)) private _minted;
    // tokenId = { x; y }
    mapping(uint256 => Coordinates) private _coordinates;

    uint256 private _lastX;
    uint256 private _lastY;

    constructor() ERC721("Land of Kingdom of Polygon", "Land") {}

    function mintTo(address _to, uint256 _x, uint256 _y) internal {
        require(!_minted[_x][_y], "mintTo: already claimed.");
        uint256 nextId = totalSupply();
        _lands[_x][_y] = nextId;
        _coordinates[nextId] = Coordinates(_x, _y);
        _mint(_to, nextId);
        console.log("Minting x:'%d' y:'%d', id: '%s'", uint256(_x), uint256(_y), nextId);
    }

    function mintWorld() public {
        console.log("governance mint");

        uint256 size = 20;
        uint256 _nextX = _lastX + size;
        uint256 _nextY = _lastY + size;

        if (_nextX > WORLD_SIZE) {
            _nextX = WORLD_SIZE;
        }

        if (_nextY > WORLD_SIZE) {
            _nextY = WORLD_SIZE;
        }

        for (uint256 x = _lastX; x < _nextX; x++) {
            _lastX = x;
            for (uint256 y = _lastY; y <= _nextY; y++) {
                _lastY = y;
                if (!_minted[x][y]) {
                    mintTo(owner(), x, y);
                }
            }
        }
    }
}
