function getShareOfTotalBoostedBalance(address user) external view override returns (uint256) {
        return balances[user].scaledMul(boostFactors[user]).scaledDiv(totalLockedBoosted);
    }