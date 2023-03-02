// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error Staking__TransferFailed();
error Staking__NeedMoreThanZero();

contract Staking {
    IERC20 public s_stakingToken;
    IERC20 public s_rewardToken;

    // someones address -> how much they staked
    mapping(address => uint256) public s_balances;
    // a mapping how much each address has been paid
    mapping(address => uint256) public s_userRewardPerTokenPaid;
    // a mapping how much reward each address has
    mapping(address => uint256) public s_rewards;

    uint256 public constant REWARD_RATE = 100;
    uint256 public s_totalSupply;
    uint256 public s_rewardPerTokenStored;
    uint256 public s_lastUpdateTime;

    modifier updateReward(address account) {
        s_rewardPerTokenStored = rewardPerToken();
        s_lastUpdateTime = block.timestamp;
        s_rewards[account] = earned(account);
        s_userRewardPerTokenPaid[account] = s_rewardPerTokenStored;
        _;
    }

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert Staking__NeedMoreThanZero();
        }
        _;
    }

    constructor(address stakingToken, address rewardToken) {
        s_stakingToken = IERC20(stakingToken);
        s_rewardToken = IERC20(rewardToken);
    }

    function earned(address acccount) public view returns (uint256) {
        uint256 currentBalance = s_balances[acccount];
        // How much they have been paid already
        uint256 amountPaid = s_userRewardPerTokenPaid[acccount];
        uint256 currentRewardPerToken = rewardPerToken();
        uint256 pastRewards = s_rewards[acccount];
        uint256 earn = ((currentBalance *
            (currentRewardPerToken - amountPaid)) / 1e18) + pastRewards;

        return earn;
    }

    function rewardPerToken() public view returns (uint256) {
        if (s_totalSupply == 0) {
            return s_rewardPerTokenStored;
        }
        return
            s_rewardPerTokenStored +
            (
                (((block.timestamp - s_lastUpdateTime) * REWARD_RATE * 1e18) /
                    s_totalSupply)
            );
    }

    function stake(
        uint256 amount
    ) public updateReward(msg.sender) moreThanZero(amount) {
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

    function withDraw(
        uint256 amount
    ) external updateReward(msg.sender) moreThanZero(amount) {
        s_balances[msg.sender] -= amount;
        s_totalSupply -= amount;
        bool success = s_stakingToken.transfer(msg.sender, amount);
        if (!success) {
            revert Staking__TransferFailed();
        }
    }

    function claimReward() external updateReward(msg.sender) {
        uint256 reward = s_rewards[msg.sender];
        bool success = s_rewardToken.transfer(msg.sender, reward);
        if (!success) {
            revert Staking__TransferFailed();
        }
    }

    function getStaked(address account) public view returns (uint256) {
        return s_balances[account];
    }
}
