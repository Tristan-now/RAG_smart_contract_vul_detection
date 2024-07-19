function getInternalTotalSupply() external view override returns (uint256) {
    return SherXStorage.sx().internalTotalSupply;
  }