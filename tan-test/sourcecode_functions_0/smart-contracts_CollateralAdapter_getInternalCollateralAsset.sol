function getInternalCollateralAsset(address _externalAsset) external view returns (address) {
    return _collateralAssets[_externalAsset];
  }