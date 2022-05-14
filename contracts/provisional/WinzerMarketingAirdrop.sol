// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../winzers/WinzerERC721.sol";

/**
 * @dev contract allows to mint special winzer called mother for contract owner
 * @dev owner also can mint up to 98 winzers whos parents will be winzer 0 and winzer 1
 * @dev owner can choose how winzers will look, but minted winzers can't have any skills.
 */
contract WinzerMarketingAirdrop is Ownable {
    uint public constant MAX_TO_AIRDROP = 98;
    bool public motherMinted;
    uint public airdroped;

    WinzerERC721 public winzerContract;

    constructor(address _winzerContract) {
        winzerContract = WinzerERC721(_winzerContract);
    }
    
    function mintMother() public onlyOwner returns (uint256) {

        require(!motherMinted, "Mother already minted.");

        motherMinted = true;

        WinzerERC721.DNA1 memory _dna;
        _dna.race = 0;
        _dna.sex = 1;
        _dna.skin = 3;
        _dna.head = 0;
        _dna.ears = 2;
        _dna.hair = 4;
        _dna.beard = 0;
        _dna.mouth = 13;
        _dna.eyes = 9;
        _dna.eyebrows = 8;
        _dna.nose = 2;
        _dna.scars = 0;

        WinzerERC721.DNA2 memory _extraDna;
        _extraDna.makeup = 4;
        _extraDna.accessory = 10;

        // Make her her own parent
        _extraDna.father = 1;
        _extraDna.mother = 1;

        return winzerContract.mint(_msgSender(), _dna, _extraDna);
    }

    function mint(address _receiver, WinzerERC721.DNA1 memory _dna1) public onlyOwner returns (uint256) {
        require(motherMinted, "Mint mother first");
        require(canMint(), "Limit reached.");
        airdroped = airdroped + 1;

        WinzerERC721.DNA2 memory _dna2;
        _dna2.father = 0;
        _dna2.mother = 1;
        return winzerContract.mint(_receiver, _dna1, _dna2);
    }

    function canMint() public view returns (bool) {
        return airdroped < MAX_TO_AIRDROP;
    }
}
