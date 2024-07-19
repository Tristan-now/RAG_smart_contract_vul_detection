function _computeNewStake(address token, uint _coll) internal view returns (uint) {
        uint stake;
        if (totalCollateralSnapshot[token] == 0) {
            stake = _coll;
        } else {
            /*
            * The following assert() holds true because:
            * - The system always contains >= 1 trove
            * - When we close or liquidate a trove, we redistribute the pending rewards, so if all troves were closed/liquidated,
            * rewards would’ve been emptied and totalCollateralSnapshot would be zero too.
            */
            require(totalStakesSnapshot[token] != 0, "TM: stake must be > 0");
            stake = _coll.mul(totalStakesSnapshot[token]).div(totalCollateralSnapshot[token]);
        }
        return stake;
    }