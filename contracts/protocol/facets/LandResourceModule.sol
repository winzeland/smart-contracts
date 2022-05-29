//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat-deploy/solc_0.8";

contract LandResourceModule {
  function setDataA(bytes32 _dataA) external {
    LibA.DiamondStorage storage ds = LibA.diamondStorage();
    require(ds.owner == msg.sender, "Must be owner.");
    ds.dataA = _dataA;
  }

  function getDataA() external view returns (bytes32) {
    return LibA.diamondStorage().dataA;
  }
}
