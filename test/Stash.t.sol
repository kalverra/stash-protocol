// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "src/Stash.sol";
import "src/StashShareToken.sol";
import {Utils} from "testutils/Utils.sol";

contract StashTest is Test {
    Stash public stash;
    StashShareToken public stashToken;

    function setUp() public {
        stash = new Stash("Test Stash", "Test", "TST");
        vm.label(address(stash), "Stash");
        stashToken = StashShareToken(stash.sharesTokenAddress());
        vm.label(address(stashToken), "Stash Shares Token");
    }

    function testStashConstruction() public {
        assertEq(stash.stashName(), "Test Stash");
    }

    function testStash() public {
        assertEq(
            stashToken.balanceOf(address(this)),
            0,
            "We have more shares than expected"
        );
        (bool sent, ) = address(stash).call{value: 1 ether}("stash()");
        assertTrue(sent, "Error calling stash()");
        assertEq(
            address(stash).balance,
            1 ether,
            "Stash does not have sent ether"
        );
        assertEq(
            stashToken.balanceOf(address(this)),
            1 ether,
            "Expected token amount not here"
        );
    }

    function testRedeem() public {
        (bool sent, ) = address(stash).call{value: 1 ether}("stash()");
        assertTrue(sent, "Error calling stash()");
        assertEq(
            address(stash).balance,
            1 ether,
            "Stash does not have sent ether"
        );
        assertEq(
            stashToken.balanceOf(address(this)),
            1 ether,
            "Expected token amount not here"
        );
        stash.redeem(1 ether);
        assertEq(
            address(this).balance,
            1 ether,
            "Stash still has ether, not redeemed"
        );
        assertEq(
            stashToken.balanceOf(address(this)),
            0,
            "I still have stash shares"
        );
    }
}
