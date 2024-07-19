function totalUsefulCollateral() public view returns (uint256 collateral) {
    uint256 auctionPoolBalance = collateralToken.balanceOf(address(auctionPool));
    uint256 overflowBalance = collateralToken.balanceOf(address(rewardOverflow));
    uint256 liquidityExtensionBalance = collateralToken.balanceOf(address(liquidityExtension));
    uint256 swingTraderBalance = collateralToken.balanceOf(address(swingTrader));

    return auctionPoolBalance + overflowBalance + liquidityExtensionBalance + swingTraderBalance;
  }