function _distributeRewards(uint256 rewarded) internal {
    if (rewarded == 0) {
      return;
    }
    rewardToken.approve(address(auction), rewarded);
    rewarded = auction.allocateArbRewards(rewarded);

    if (rewarded == 0) {
      return;
    }

    uint256 callerCut = rewarded.mul(callerRewardCut).div(1000);
    uint256 lpCut = rewarded.mul(lpRewardCut).div(1000);
    uint256 daoCut = rewarded.mul(daoRewardCut).div(1000);
    uint256 auctionPoolCut = rewarded.mul(auctionPoolRewardCut).div(1000);
    uint256 swingTraderCut = rewarded.mul(swingTraderRewardCut).div(1000);

    // Treasury gets paid after everyone else
    uint256 treasuryCut = rewarded - daoCut - lpCut - callerCut - auctionPoolCut - swingTraderCut;

    assert(treasuryCut <= rewarded);

    if (callerCut > 0) {
      rewardToken.safeTransfer(msg.sender, callerCut);
    }

    if (auctionPoolCut > 0) {
      rewardToken.safeTransfer(auctionPool, auctionPoolCut);
    }

    if (swingTraderCut > 0) {
      rewardToken.safeTransfer(address(swingTrader), swingTraderCut);
    }

    if (treasuryCut > 0) {
      rewardToken.safeTransfer(treasuryMultisig, treasuryCut);
    }

    if (daoCut > 0) {
      rewardToken.safeTransfer(address(dao), daoCut);
    }

    if (lpCut > 0) {
      rewardToken.safeTransfer(address(rewardThrottle), lpCut);
      rewardThrottle.handleReward();
    }

    emit RewardDistribution(rewarded);
  }