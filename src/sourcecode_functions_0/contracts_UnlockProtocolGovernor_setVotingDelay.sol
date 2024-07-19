function setVotingDelay(uint256 newVotingDelay) public onlyGovernance {
    uint256 oldVotingDelay = _votingDelay;
    _votingDelay = newVotingDelay;
    emit VotingDelayUpdated(oldVotingDelay, newVotingDelay);
  }