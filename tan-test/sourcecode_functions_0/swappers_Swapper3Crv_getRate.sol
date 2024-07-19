function getRate(address fromToken, address toToken) external view override returns (uint256) {
        require(
            fromToken == TRI_CRV && ((toToken == DAI) || (toToken == USDC) || (toToken == USDT)),
            "Token pair not swappable"
        );
        if (toToken == DAI) return ICurveSwap(CURVE_POOL).get_virtual_price();
        return ICurveSwap(CURVE_POOL).get_virtual_price() / 1e12;
    }