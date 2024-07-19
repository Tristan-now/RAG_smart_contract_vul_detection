function getEquivalentCollateralTokens(uint256 _id, uint256 _borrowTokenAmount) external view returns (uint256) {
        address _collateralAsset = pooledCreditLineConstants[_id].collateralAsset;
        require(_collateralAsset != address(0), 'PCL:CTTL1');
        address _borrowAsset = pooledCreditLineConstants[_id].borrowAsset;

        return _equivalentCollateral(_collateralAsset, _borrowAsset, _borrowTokenAmount);
    }