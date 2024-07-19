function custodialInitiate(address u, uint256 m, address z, address n, uint256 a) external onlySwivel(swivel) returns (bool) {
    require(ZcToken(markets[u][m].zcTokenAddr).mint(z, a), 'mint failed');
    require(VaultTracker(markets[u][m].vaultAddr).addNotional(n, a), 'add notional failed');
    emit CustodialInitiate(u, m, z, n, a);
    return true;
  }