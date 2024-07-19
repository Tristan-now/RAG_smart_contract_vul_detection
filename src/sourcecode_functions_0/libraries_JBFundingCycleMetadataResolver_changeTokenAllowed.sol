function changeTokenAllowed(JBFundingCycle memory _fundingCycle) internal pure returns (bool) {
    return ((_fundingCycle.metadata >> 77) & 1) == 1;
  }