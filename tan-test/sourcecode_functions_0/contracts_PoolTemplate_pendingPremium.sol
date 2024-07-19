function pendingPremium(address _index)
        external
        view
        override
        returns (uint256)
    {
        uint256 _credit = indicies[_index].credit;
        if (_credit == 0) {
            return 0;
        } else {
            return
                _sub(
                    (_credit * rewardPerCredit) / MAGIC_SCALE_1E6,
                    indicies[_index].rewardDebt
                );
        }
    }