function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
        require(
            block.timestamp > periodFinish,
            "Previous rewards period must be complete before changing the duration for the new period"
        );
        rewardsDuration = _rewardsDuration;
        // C4-Audit Fix for Issue # 106
        emit RewardsDurationUpdated(_rewardsDuration);
    }