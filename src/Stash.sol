// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./StashShareToken.sol";

/**
 * @title A stash to hold multiple assets with tokens that can be redeemed
 * @dev At this point this is mostly a learning project with 0 audits or guarantees
 */
contract Stash {
    event Stashed(address indexed stasher, uint256 indexed amount);
    event Redeemed(address indexed redeemer, uint256 indexed amount);

    StashShareToken public shares;
    address public sharesTokenAddress;
    string public stashName;

    constructor(
        string memory _stashName,
        string memory _stashToken,
        string memory _stashTokenSymbol
    ) {
        stashName = _stashName;
        shares = new StashShareToken(_stashToken, _stashTokenSymbol);
        sharesTokenAddress = address(shares);
    }

    /**
     * @dev Deposit ETH into the stash and receive tokens
     */
    function stash() public payable {
        require(msg.value > 0, "No ETH");
        shares.mint(msg.sender, msg.value);
        emit Stashed(msg.sender, msg.value);
    }

    /**
     * @dev Redeem tokens for an equal stored amount of Eth
     */
    function redeem(uint256 stashShares) public {
        require(
            stashShares <= shares.balanceOf(msg.sender),
            "Not enough shares"
        );
        shares.redeem(msg.sender, stashShares);
        if (!payable(msg.sender).send(stashShares)) {
            revert("Error redeeming");
        }
        emit Redeemed(msg.sender, stashShares);
    }

    receive() external payable {
        stash();
    }

    fallback() external payable {
        stash();
    }
}
