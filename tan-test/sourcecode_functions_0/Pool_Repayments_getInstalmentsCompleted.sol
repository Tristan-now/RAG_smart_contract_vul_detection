function getInstalmentsCompleted(address _poolID) public view returns (uint256) {
        uint256 _repaymentInterval = repayConstants[_poolID].repaymentInterval;
        uint256 _loanDurationCovered = repayVariables[_poolID].loanDurationCovered;
        uint256 _instalmentsCompleted = _loanDurationCovered.div(_repaymentInterval).mul(SCALING_FACTOR); // dividing exponents, returns whole number rounded down

        return _instalmentsCompleted;
    }