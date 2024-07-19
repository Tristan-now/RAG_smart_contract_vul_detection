function claimablePremiums() public view override returns (uint256) {
    // Takes last balance and adds (number of seconds since last accounting update * total premiums per second)
    return
      lastClaimablePremiumsForStakers +
      (block.timestamp - lastAccountedGlobal) *
      allPremiumsPerSecToStakers;
  }