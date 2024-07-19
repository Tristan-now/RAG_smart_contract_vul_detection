function _addLiquidity721WETH(
    uint256 vaultId, 
    uint256[] memory ids, 
    uint256 minWethIn,
    uint256 wethIn,
    address to
  ) internal returns (uint256, uint256, uint256) {
    address vault = nftxFactory.vault(vaultId);
    require(vault != address(0), "NFTXZap: Vault does not exist");

    // Transfer tokens to zap and mint to NFTX.
    address assetAddress = INFTXVault(vault).assetAddress();
    for (uint256 i = 0; i < ids.length; i++) {
      transferFromERC721(assetAddress, ids[i]);
      approveERC721(assetAddress, vault, ids[i]);
    }
    uint256[] memory emptyIds;
    uint256 count = INFTXVault(vault).mint(ids, emptyIds);
    uint256 balance = (count * BASE); // We should not be experiencing fees.
    require(balance == IERC20Upgradeable(vault).balanceOf(address(this)), "Did not receive expected balance");
    
    return _addLiquidityAndLock(vaultId, vault, balance, minWethIn, wethIn, to);
  }