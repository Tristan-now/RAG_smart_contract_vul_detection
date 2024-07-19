function getSwapOutput(
    address _input,
    address _output,
    uint256 _inputQuantity
  ) external view override returns (uint256 swapOutput) {
    require(_input != _output, "Invalid pair");
    require(_inputQuantity > 0, "Invalid swap quantity");

    // 1. Load the bAssets from storage
    Asset memory input = _getAsset(_input);
    Asset memory output = _getAsset(_output);

    // 2. If a bAsset swap, calculate the validity, output and fee
    (swapOutput, ) = MassetLogic.computeSwap(
      data.bAssetData,
      input.idx,
      output.idx,
      _inputQuantity,
      data.swapFee,
      _getConfig()
    );
  }