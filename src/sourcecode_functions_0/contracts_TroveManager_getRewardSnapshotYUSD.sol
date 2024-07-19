function getRewardSnapshotYUSD(address _borrower, address _token) external view override returns (uint) {
        return rewardSnapshots[_borrower].YUSDDebts[_token];
    }