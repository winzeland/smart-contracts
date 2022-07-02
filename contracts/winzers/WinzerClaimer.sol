// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "./WinzerERC721.sol";

// contract build for testnets
// it allows everyone to mint "random" winzer to their wallet
contract WinzerClaimer is Context {
    WinzerERC721 public winzerContract;

    constructor(address _winzerContract) {
        winzerContract = WinzerERC721(_winzerContract);
    }

    function mint(WinzerERC721.DNA1 memory _dna1, WinzerERC721.DNA2 memory _dna2) public returns (uint256) {
        return winzerContract.mint(_msgSender(), _dna1, _dna2);
    }

    function claim() public returns (uint256) {

        WinzerERC721.DNA1 memory _dna;
        _dna.race = 0;
        _dna.sex = random(1, 2);
        _dna.skin = random(2, 6);
        _dna.head = random(3, 3);
        _dna.ears = random(4, 3);
        _dna.hair = random(5, 11);
        _dna.beard = random(6, 15);
        _dna.mouth = random(7, 14);
        _dna.eyes = random(8, 11);
        _dna.eyebrows = random(9, 10);
        _dna.nose = random(10, 4);
        // _dna.scars = random(11, 3);

        WinzerERC721.DNA2 memory _extraDna;
        _extraDna.makeup = random(12, 6);
        _extraDna.accessory = random(13, 13);
        _extraDna.father = random(14, uint8(winzerContract.totalSupply() - 1));
        _extraDna.mother = random(15, uint8(winzerContract.totalSupply() - 1));
    
        return winzerContract.mint(_msgSender(), _dna, _extraDna);
    }

    // predictable random number - it's ok, we are only using this contract for testnets.
    function random(uint8 _type, uint8 _max) private view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, _type, _max))) % _max);
    }

}
