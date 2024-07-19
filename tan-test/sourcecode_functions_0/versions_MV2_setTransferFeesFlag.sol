function setTransferFeesFlag(address _bAsset, bool _flag)
    external
    override
    onlyGovernor
  {
    MassetManager.setTransferFeesFlag(
      data.bAssetPersonal,
      bAssetIndexes,
      _bAsset,
      _flag
    );
  }