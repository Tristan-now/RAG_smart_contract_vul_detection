function setCollateralMinCollateralRatio(address _collateralType, uint256 _minCollateralRatio)
    public
    override
    onlyManager
  {
    require(_minCollateralRatio >= _collateralConfigs[collateralIds[_collateralType]].liquidationRatio);
    _collateralConfigs[collateralIds[_collateralType]].minCollateralRatio = _minCollateralRatio;
    _emitUpdateEvent(_collateralType);
  }