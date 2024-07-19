function _equivalentCollateral(
        address _collateralAsset,
        address _borrowAsset,
        uint256 _borrowTokenAmount
    ) private view returns (uint256) {
        (uint256 _ratioOfPrices, uint256 _decimals) = PRICE_ORACLE.getLatestPrice(_collateralAsset, _borrowAsset);
        uint256 _collateralTokenAmount = (_borrowTokenAmount.mul(10**_decimals).div(_ratioOfPrices));

        return _collateralTokenAmount;
    }