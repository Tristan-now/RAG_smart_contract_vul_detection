function changeMarketLaunchIncentiveParameters(
    uint32 marketIndex,
    uint256 period,
    uint256 initialMultiplier
  ) external onlyAdmin {
    _changeMarketLaunchIncentiveParameters(marketIndex, period, initialMultiplier);

    emit MarketLaunchIncentiveParametersChanges(marketIndex, period, initialMultiplier);
  }