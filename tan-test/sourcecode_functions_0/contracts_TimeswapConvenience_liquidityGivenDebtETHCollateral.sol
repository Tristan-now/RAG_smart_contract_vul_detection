function liquidityGivenDebtETHCollateral(LiquidityGivenDebtETHCollateral calldata params)
        external
        payable
        override
        returns (
            uint256 assetIn,
            uint256 liquidityOut,
            uint256 id,
            IPair.Due memory dueOut
        )
    {
        (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenDebtETHCollateral(this, factory, weth, params);
    }