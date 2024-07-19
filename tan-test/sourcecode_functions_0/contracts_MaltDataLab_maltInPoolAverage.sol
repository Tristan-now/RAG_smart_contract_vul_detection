function maltInPoolAverage(uint256 _lookback) public view returns (uint256) {
    return poolMaltReserveMA.getValueWithLookback(_lookback);
  }