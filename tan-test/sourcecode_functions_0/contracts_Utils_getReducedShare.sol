function getReducedShare(uint amount, uint rewardReductionFactor) public pure returns(uint) {
        return calcShare(1, rewardReductionFactor, amount); // Reduce to stop depleting fast
    }