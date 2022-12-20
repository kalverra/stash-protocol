// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StashShareToken is ERC20, Ownable {
    constructor(string memory tokenName, string memory tokenSymbol)
        ERC20(tokenName, tokenSymbol)
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function redeem(address redeemer, uint256 amount) public onlyOwner {
        _burn(redeemer, amount);
    }
}
