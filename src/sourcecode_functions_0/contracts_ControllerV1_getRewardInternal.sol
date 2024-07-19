function getRewardInternal(LPoolInterface lpool, address account, bool isBorrow) internal {
        uint256 reward = lPoolRewardByAccounts[lpool][isBorrow][account].rewards;
        if (reward > 0) {
            bool succeed = transferOut(account, reward);
            if (succeed) {
                lPoolRewardByAccounts[lpool][isBorrow][account].rewards = 0;
                emit PoolReward(address(lpool), account, isBorrow, reward);
            }
        }
    }