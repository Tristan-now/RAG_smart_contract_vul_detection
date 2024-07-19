function _addCollateralAssets(ISetToken _setToken, IERC20[] memory _newCollateralAssets) internal {
        for(uint256 i = 0; i < _newCollateralAssets.length; i++) {
            IERC20 collateralAsset = _newCollateralAssets[i];

            _validateNewCollateralAsset(_setToken, collateralAsset);
            _updateUseReserveAsCollateral(_setToken, collateralAsset, true);

            collateralAssetEnabled[_setToken][collateralAsset] = true;
            enabledAssets[_setToken].collateralAssets.push(address(collateralAsset));
        }
        emit CollateralAssetsUpdated(_setToken, true, _newCollateralAssets);
    }