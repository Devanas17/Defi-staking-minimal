// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error Staking__TransferFailed();

contract Staking {
    IERC20 public s_stakingToken;

    mapping(address => uint256) public s_balances;

    uint256 public s_totalSupply;

    constructor(address stakingToken) {
        s_stakingToken = IERC20(stakingToken);
    }

    function stake(uint256 amount) public {
        // Keep track of how much this user has staked
        // keep track of how much token we have total
        // Transfer the tokens to this contract

        s_balances[msg.sender] += amount;
        s_totalSupply += amount;

        bool success = s_stakingToken.transferFrom(
            msg.sender,
            address(this),
            amount
        );
        if (!success) {
            revert Staking__TransferFailed();
        }
    }

    function withDraw(uint256 amount) external {
        s_balances[msg.sender] -= amount;
        s_totalSupply -= amount;
        bool success = s_stakingToken.transfer(msg.sender, amount);
        if (!success) {
            revert Staking__TransferFailed();
        }
    }

    function claimReward() external {}
}
