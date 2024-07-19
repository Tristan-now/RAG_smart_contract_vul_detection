function getLiquidityTokenValue( uint256 index, CashGroupParameters memory cashGroup, MarketParameters memory market, PortfolioAsset[] memory assets, uint256 blockTime, bool riskAdjusted ) internal view returns (int256, int256) {
    PortfolioAsset memory liquidityToken = assets[index];
    require(
        isLiquidityToken(liquidityToken.assetType) &&
            liquidityToken.notional >= 0
    ); // dev: get liquidity token value, not liquidity token

    {
        (uint256 marketIndex, bool idiosyncratic) = DateTime.getMarketIndex(
            cashGroup.maxMarketIndex,
            liquidityToken.maturity,
            blockTime
        );
        // Liquidity tokens can never be idiosyncratic
        require(!idiosyncratic); // dev: idiosyncratic liquidity token

        // This market will always be initialized, if a liquidity token exists that means the market has some liquidity in it.
        cashGroup.loadMarket(market, marketIndex, true, blockTime);
    }

    int256 assetCashClaim;
    int256 fCashClaim;
    if (riskAdjusted) {
        (assetCashClaim, fCashClaim) = getHaircutCashClaims(
            liquidityToken,
            market,
            cashGroup
        );
    } else {
        (assetCashClaim, fCashClaim) = getCashClaims(liquidityToken, market);
    }

    // Find the matching fCash asset and net off the value, assumes that the portfolio is sorted and
    // in that case we know the previous asset will be the matching fCash asset
    if (
        index > 0 &&
        assets[index - 1].currencyId == liquidityToken.currencyId &&
        assets[index - 1].maturity == liquidityToken.maturity &&
        assets[index - 1].assetType == Constants.FCASH_ASSET_TYPE
    ) {
        // Net off the fCashClaim here and we will discount it to present value in the second pass.
        // WARNING: this modifies the portfolio in memory and therefore we cannot store this portfolio!
        assets[index - 1].notional = assets[index - 1].notional.add(fCashClaim);
        return (assetCashClaim, 0);
    }

    // If not matching fCash asset found then get the pv directly
    if (riskAdjusted) {
        int256 pv = getRiskAdjustedPresentValue(
            cashGroup,
            fCashClaim,
            liquidityToken.maturity,
            blockTime,
            market.oracleRate
        );

        return (assetCashClaim, pv);
    } else {
        int256 pv = getPresentValue(
            fCashClaim,
            liquidityToken.maturity,
            blockTime,
            market.oracleRate
        );

        return (assetCashClaim, pv);
    }
}