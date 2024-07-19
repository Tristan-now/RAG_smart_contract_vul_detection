function _release(uint256 _totalnewTokensReceived, address _payee) internal override {
    uint256 payment = _totalnewTokensReceived.mul(shares[_payee]).div(totalShares);
    IERC20(a.mimo()).safeTransfer(_payee, payment);
  }