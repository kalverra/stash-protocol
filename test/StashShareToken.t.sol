// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "src/StashShareToken.sol";

contract StashShareTokenTest is Test {
    StashShareToken public stashShareToken;

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
        // vm.expectRevert(Unauthorized.selector);
        vm.prank(address(0));
        stashShareToken.redeem(1);
    }

    function testMintNotOwner() public {
        // vm.expectRevert(Unauthorized.selector);
        vm.prank(address(0));
        stashShareToken.mint(1);
    }
}
