function _setProtocolPremiumAndTokenPrice(
    bytes32 _protocol,
    IERC20 _token,
    uint256 _premium,
    uint256 _newUsd,
    uint256 usdPerBlock,
    uint256 usdPool
  ) private returns (uint256, uint256) {
    PoolStorage.Base storage ps = PoolStorage.ps(_token);
    onlyValidToken(ps, _token);

    uint256 oldUsd = _setTokenPrice(_token, _newUsd);
    (uint256 oldPremium, uint256 newPremium) = _setProtocolPremium(ps, _protocol, _premium);
    (usdPerBlock, usdPool) = _updateData(
      ps,
      usdPerBlock,
      usdPool,
      oldPremium,
      newPremium,
      oldUsd,
      _newUsd
    );
    return (usdPerBlock, usdPool);
  }