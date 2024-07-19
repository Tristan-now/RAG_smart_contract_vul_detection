function setKickIncentive(uint256 _rate, uint256 _delay)
        external
        onlyOwner
    {
        require(_rate <= 500, "over max rate"); //max 5% per epoch
        require(_delay >= 2, "min delay"); //minimum 2 epochs of grace
        kickRewardPerEpoch = _rate;
        kickRewardEpochDelay = _delay;
    }