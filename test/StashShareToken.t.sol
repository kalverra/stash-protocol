// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "src/StashShareToken.sol";
import {Utils} from "./Utils.sol";

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
}
