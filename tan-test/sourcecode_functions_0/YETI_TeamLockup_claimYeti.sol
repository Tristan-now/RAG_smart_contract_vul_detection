function claimYeti(uint _amount) external onlyMultisig {
        require(block.timestamp > vestingStart, "Vesting hasn't started yet");
        require(totalClaimed < totalVest, "All YETI has been vested");

        uint timePastVesting = block.timestamp.sub(vestingStart);

        uint available = _min(totalVest,(totalVest.mul(timePastVesting)).div(vestingLength));
        if (available >= totalClaimed.add(_amount)) {
            // there are _amount YETI tokens that are claimable
            totalClaimed = totalClaimed.add(_amount);
            require(YETI.transfer(multisig, _amount));
        }
    }