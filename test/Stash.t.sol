// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "src/Stash.sol";
import "src/StashShareToken.sol";
import {Utils} from "./Utils.sol";

contract StashTest is Test {
    Stash public stash;
    StashShareToken public stashToken;

    Utils internal utils;
    address payable[] internal users;
    address internal alice;
    address internal bob;

    function setUp() public {
        utils = new Utils();
        users = utils.createUsers(2);
        alice = users[0];
        vm.label(alice, "Alice");
        bob = users[1];
        vm.label(bob, "Bob");

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

    function testRedeem() public {
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
