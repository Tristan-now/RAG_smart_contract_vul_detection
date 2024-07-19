function votingPowerOf(address account) external view returns (uint256) {
        return getVotingPower(balanceOf(account));
    }