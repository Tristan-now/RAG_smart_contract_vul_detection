function burnSurplus() external returns (uint256 burnAmount) {
    InvariantConfig memory config = _getConfig();
    (, uint256 k) = MassetLogic.computePrice(data.bAssetData, config);
    require(config.supply > k, "No surplus");
    burnAmount = config.supply - k;
    // Transfer to ensure approval has been given
    transferFrom(msg.sender, address(this), burnAmount);

    _burn(address(this), burnAmount);
    emit SurplusBurned(msg.sender, burnAmount);
  }