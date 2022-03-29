//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTConstructionRegistry is Ownable {
    mapping(address => bool) public constructions;
}

contract NFTConstructions is ERC721, Ownable {

    struct Construction {
        bytes32 constructionType;
        uint16 constructionLevel;
    }

    mapping(uint256 => uint16) public levels;

    constructor() ERC721("Constructions", "Construction") {}

    function construct(address to, Construction memory construction) public {
        
    }
}
