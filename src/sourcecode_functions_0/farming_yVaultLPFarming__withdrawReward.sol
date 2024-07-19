function _withdrawReward(address account) internal returns (uint256) {
        uint256 pending = (balanceOf[account] *
            (accRewardPerShare - userLastAccRewardPerShare[account])) / 1e36;

        if (pending > 0) userPendingRewards[account] += pending;

        userLastAccRewardPerShare[account] = accRewardPerShare;

        return pending;
    }