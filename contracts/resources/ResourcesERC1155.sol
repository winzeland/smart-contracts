//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ResourcesERC1155 is ERC1155, Ownable {
    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        // _mint(msg.sender, GOLD, 10**18, "");
    }

    // todo: allow only owner / minter
    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) public onlyOwner {
        _mint(to, id, amount, "");
    }

    // todo: allow only owner / burner
    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public onlyOwner {
        _burn(account, id, value);
    }
}
