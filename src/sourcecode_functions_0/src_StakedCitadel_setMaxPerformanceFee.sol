function setMaxPerformanceFee(uint256 _fees) external {
        _onlyGovernance();
        require(
            _fees <= PERFORMANCE_FEE_HARD_CAP,
            "performanceFeeStrategist too high"
        );

        maxPerformanceFee = _fees;
        emit SetMaxPerformanceFee(_fees);
    }