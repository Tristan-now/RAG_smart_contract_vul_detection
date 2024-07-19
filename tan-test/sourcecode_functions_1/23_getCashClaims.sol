function getCashClaims( PortfolioAsset memory token, MarketParameters memory market ) internal pure returns (int256 assetCash, int256 fCash) {
    require(isLiquidityToken(token.assetType) && token.notional >= 0); // dev: invalid asset, get cash claims

    assetCash = market.totalAssetCash.mul(token.notional).div(
        market.totalLiquidity
    );
    fCash = market.totalfCash.mul(token.notional).div(market.totalLiquidity);
}