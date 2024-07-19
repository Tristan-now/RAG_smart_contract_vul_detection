function repayETHAsset(RepayETHAsset memory params)
        external
        payable
        override
        returns (uint128 assetIn, uint128 collateralOut)
    {
        (assetIn, collateralOut) = natives.payETHAsset(factory, weth, params);
    }