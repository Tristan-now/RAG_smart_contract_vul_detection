function getHaircutCashClaims( PortfolioAsset memory token, MarketParameters memory market, CashGroupParameters memory cashGroup ) internal pure returns (int256, int256) {
    require(isLiquidityToken(token.assetType) && token.notional >= 0); // dev: invalid asset get haircut cash claims

    require(token.currencyId == cashGroup.currencyId); // dev: haircut cash claims, currency id mismatch
    // This won't overflow, the liquidity token haircut is stored as an uint8
    int256 haircut = int256(cashGroup.getLiquidityHaircut(token.assetType));

    int256 assetCash = _calcToken(
        market.totalAssetCash,
        token.notional,
        haircut,
        market.totalLiquidity
    );

    int256 fCash = _calcToken(
        market.totalfCash,
        token.notional,
        haircut,
        market.totalLiquidity
    );

    return (assetCash, fCash);
}