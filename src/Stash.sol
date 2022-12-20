// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./StashShareToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title A stash to hold multiple assets with tokens that can be redeemed
 * @dev At this point this is mostly a learning project with 0 audits or guarantees
 */
contract Stash is Ownable {
    /* ============ Events ============ */
    event Stashed(address indexed stasher, uint256 indexed amount);
    event Redeemed(address indexed redeemer, uint256 indexed amount);
    event SetStashTargetDistribution();

    /* ============ State Variables ============ */

    // Target distribution amounts
    mapping(address => uint256) public stashTargetDistribution;

    // The token that indicates shares of the stash
    StashShareToken public shares;

    // The token address for shares of the stash
    address public sharesTokenAddress;

    // The full name of the stash
    string public stashName;

    // Create our stash and share tokens
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
     * Big old TODO, this looks like it will be more complicated than I thought
     */
    function setDistribution() public onlyOwner {
        emit SetStashTargetDistribution();
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
