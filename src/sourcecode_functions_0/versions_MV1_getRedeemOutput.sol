function getRedeemOutput(address _output, uint256 _mAssetQuantity)
    external
    view
    override
    returns (uint256 bAssetOutput)
  {
    require(_mAssetQuantity > 0, "Qty==0");

    Asset memory output = _getAsset(_output);

    (bAssetOutput, ) = MassetLogic.computeRedeem(
      data.bAssetData,
      output.idx,
      _mAssetQuantity,
      _getConfig(),
      data.swapFee
    );
  }