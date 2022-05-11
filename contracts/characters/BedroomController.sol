// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WinzerERC721.sol";

contract BedroomController {
    WinzerERC721 public winzerContract;

    mapping (uint256 => uint8) public kidCount;
    
    constructor(address _winzerContract) {
        winzerContract = WinzerERC721(_winzerContract);
    }



}
