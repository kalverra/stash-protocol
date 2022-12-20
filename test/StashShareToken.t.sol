// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "src/StashShareToken.sol";

contract StashShareTokenTest is Test {
    StashShareToken public stashShareToken;

    address internal alice = makeAddr("Alice");

    function setUp() public {
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
