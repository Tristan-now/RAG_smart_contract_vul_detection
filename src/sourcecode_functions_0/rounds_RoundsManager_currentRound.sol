function currentRound() public view returns (uint256) {
        // Compute # of rounds since roundLength was last updated
        uint256 roundsSinceUpdate = blockNum().sub(lastRoundLengthUpdateStartBlock).div(roundLength);
        // Current round = round that roundLength was last updated + # of rounds since roundLength was last updated
        return lastRoundLengthUpdateRound.add(roundsSinceUpdate);
    }