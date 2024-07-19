function pendingAccountReward(address _account, address _pair) external view returns(uint) {
    ILendingPair pair = ILendingPair(_pair);
    return pendingTokenReward(_account, _pair, pair.tokenA()) + pendingTokenReward(_account, _pair, pair.tokenB());
  }