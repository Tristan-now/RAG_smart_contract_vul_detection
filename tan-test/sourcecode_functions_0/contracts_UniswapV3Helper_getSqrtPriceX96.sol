function getSqrtPriceX96(uint _amount0, uint _amount1) public view returns(uint) {
    uint ratioX192 = (_amount0 << 192) / _amount1;
    return _sqrt(ratioX192);
  }