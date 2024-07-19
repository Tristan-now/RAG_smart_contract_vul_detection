function setSpendRatio(uint256 _spendRatio) external onlyGovernance returns (bool) {
        require(
            _spendRatio <= ICvxLocker(CVX_LOCKER).maximumBoostPayment(),
            Error.EXCEEDS_MAX_BOOST
        );
        spendRatio = _spendRatio;
        emit NewSpendRatio(_spendRatio);
        return true;
    }