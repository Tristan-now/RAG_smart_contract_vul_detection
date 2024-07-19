function requireMarketExistsModifierLogic(uint32 marketIndex) internal view virtual {
    require(marketExists[marketIndex], "market doesn't exist");
  }