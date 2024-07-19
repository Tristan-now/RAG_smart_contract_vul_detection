function getTickAtSqrtRatio(uint160 _sqrtPriceX96) public pure returns (int24) {
    return TickMath.getTickAtSqrtRatio(_sqrtPriceX96);
  }