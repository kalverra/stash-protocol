// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "src/StashShareToken.sol";
import {Utils} from "testutils/Utils.sol";

contract StashShareTokenTest is Test {
    StashShareToken public stashShareToken;

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

        stashShareToken = new StashShareToken("Test", "TST");
        vm.label(address(stashShareToken), "StashShareToken");
    }

    function testRedeemNotOwner() public {
        vm.prank(address(0));
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        stashShareToken.redeem(alice, 1);
    }

    function testMintNotOwner() public {
        vm.prank(address(0));
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        stashShareToken.mint(alice, 1);
    }

    function testMint() public {
        stashShareToken.mint(alice, 1);
        assertEq(stashShareToken.balanceOf(alice), 1);
    }

    function testRedeem() public {
        stashShareToken.mint(alice, 1);
        assertEq(stashShareToken.balanceOf(alice), 1);
        stashShareToken.redeem(alice, 1);
        assertEq(stashShareToken.balanceOf(alice), 0);
    }

    function testRedeemNoBalance() public {
        assertEq(stashShareToken.balanceOf(alice), 0);
        vm.expectRevert(bytes("ERC20: burn amount exceeds balance"));
        stashShareToken.redeem(alice, 1);
    }
}
