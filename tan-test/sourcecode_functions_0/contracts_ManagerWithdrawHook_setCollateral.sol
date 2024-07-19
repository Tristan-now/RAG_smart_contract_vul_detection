function setCollateral(ICollateral _newCollateral) external override onlyRole(SET_COLLATERAL_ROLE) {
    collateral = _newCollateral;
    emit CollateralChange(address(_newCollateral));
  }