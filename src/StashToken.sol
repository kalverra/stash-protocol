// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StashToken is ERC20 {
    constructor() ERC20("STASH", "STSH") {}
}
