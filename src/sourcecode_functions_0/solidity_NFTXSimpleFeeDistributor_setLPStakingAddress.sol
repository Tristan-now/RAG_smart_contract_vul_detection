function setLPStakingAddress(address _lpStaking) public override onlyOwner {
    require(_lpStaking != address(0), "LPStaking != address(0)");
    lpStaking = _lpStaking;
    emit UpdateLPStakingAddress(_lpStaking);
  }