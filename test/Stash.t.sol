// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "src/Stash.sol";
import "src/StashShareToken.sol";

contract StashTest is Test {
    Stash public stash;
    StashShareToken public stashToken;

    address internal alice = makeAddr("Alice");

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
        vm.deal(alice, 1 ether);
        assertEq(
            stashToken.balanceOf(alice),
            0,
            "We have more shares than expected"
        );
        vm.prank(alice);
        (bool sent, ) = address(stash).call{value: 1 ether}("stash()");
        assertTrue(sent, "Error calling stash()");
        assertEq(
            address(stash).balance,
            1 ether,
            "Stash does not have sent ether"
        );
        assertEq(
            stashToken.balanceOf(alice),
            1 ether,
            "Alice doesn't expected Stash token amount"
        );
    }

    function testStashInsufficientFunds() public {
        vm.prank(alice);
        (bool sent, ) = address(stash).call{value: 1 ether}("stash()"); // Try and stash when we have 0 eth
        assertFalse(sent, "Tx should have reverted with no funds");

        vm.prank(alice);
        (sent, ) = address(stash).call("stash()"); // Try when specifying no eth
        assertFalse(sent, "Shouldn't be able to stash with 0 eth value");
    }

    function testRedeem() public {
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        (bool sent, ) = address(stash).call{value: 1 ether}("stash()");
        assertTrue(sent, "Error calling stash()");
        assertEq(
            address(stash).balance,
            1 ether,
            "Stash does not have sent ether"
        );
        assertEq(
            stashToken.balanceOf(alice),
            1 ether,
            "Alice doesn't have her balance of stash tokens"
        );
        vm.prank(alice);
        stash.redeem(1 ether);
        assertEq(
            address(stash).balance,
            0,
            "Stash still has ether, not redeemed"
        );
        assertEq(
            stashToken.balanceOf(alice),
            0,
            "Alice still has stash shares"
        );
    }
}
