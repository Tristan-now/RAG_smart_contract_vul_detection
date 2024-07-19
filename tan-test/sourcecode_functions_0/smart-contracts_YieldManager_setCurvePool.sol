function setCurvePool(
    address _tokenIn,
    address _tokenOut,
    address _pool
  ) external onlyAdmin {
    require(_pool != address(0), Errors.VT_INVALID_CONFIGURATION);
    _curvePools[_tokenIn][_tokenOut] = _pool;
  }