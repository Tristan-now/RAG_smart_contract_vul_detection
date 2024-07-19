function removePool(address _token) external onlyOwner {
    pools[_token] = Pool(address(0), 0);
    emit PoolRemoved(_token);
  }