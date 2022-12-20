// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "src/StashToken.sol";

contract StashTokenTest is Test {
    StashToken public stashToken;

    function setUp() public {
        stashToken = new StashToken();
    }

    function testConstruction() public {
        assertEq("STASH", stashToken.name());
        assertEq("STSH", stashToken.symbol());
        assertEq(1000000000000000000000000, stashToken.totalSupply());
    }
}
