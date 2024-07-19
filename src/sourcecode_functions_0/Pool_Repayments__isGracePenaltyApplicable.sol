function _isGracePenaltyApplicable(address _poolID, uint256 _nextInstalmentDeadline) private view returns (bool) {
        uint256 _repaymentInterval = repayConstants[_poolID].repaymentInterval;
        uint256 _currentTime = block.timestamp.mul(SCALING_FACTOR);
        uint256 _gracePeriodFraction = repayConstants[_poolID].gracePeriodFraction;
        uint256 _gracePeriodDeadline = _nextInstalmentDeadline.add(_gracePeriodFraction.mul(_repaymentInterval).div(SCALING_FACTOR));

        require(_currentTime <= _gracePeriodDeadline, 'R:IGPA1');

        if (_currentTime <= _nextInstalmentDeadline) return false;
        else return true;
    }