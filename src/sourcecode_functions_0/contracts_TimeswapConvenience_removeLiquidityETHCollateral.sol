function removeLiquidityETHCollateral(RemoveLiquidityETHCollateral calldata params)
        external
        override
        returns (uint256 assetOut, uint128 collateralOut)
    {
        (assetOut, collateralOut) = natives.removeLiquidityETHCollateral(factory, weth, params);
    }