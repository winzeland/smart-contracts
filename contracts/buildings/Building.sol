//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../ProtocolSettings.sol";

contract BuildingState {
    uint256 public workerId;
    uint256 public workerStartedAt;
    // if worker removed before job is finished, use this to calculate continuing time.
    uint256 public workerRemovedAt;
    // todo 3 minutes is for testing only, change it later.
    uint256 public mintTime = 3 minutes;
    bool public restartAfterWorkerRemoval;


    struct BuildingData {
        address owner;
    }

}

contract BuildingEvents {
 //
}

/**
 * @dev Contract is responsable of minting and burning our Penny tokens.
 * 
 * For minting, it takes gold bar from user and gives penny tokens.
 * For burning, it takes pennies and gives back gold bars.
 * 
 * Minting and burning will collect fees too.
 */
contract Building is Ownable, BuildingState, BuildingEvents {
    ProtocolSettings public settings;
    function startWork() public {}
    function stopWork() public {}
    function takeProducts(uint256[] memory ids) public {}
}
