function baseData() internal view returns (PoolStorage.Base storage ps) {
    ps = PoolStorage.ps(bps());
    require(ps.govPool != address(0), 'INVALID_TOKEN');
  }