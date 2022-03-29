//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ProtocolSettings is Ownable {
    // contract for penny erc-20 token
    address public token;
    // contract for resources erc-1155 tokens
    address public resources;
    // contract for resources erc-721 tokens
    address public land;

    function setToken(address _token) public onlyOwner() {
        token = _token;
    }

    function setResources(address _resources) public onlyOwner() {
        resources = _resources;
    }

    function setLand(address _land) public onlyOwner() {
        land = _land;
    }
}
