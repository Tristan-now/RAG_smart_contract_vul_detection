function checkRewardUnderflow() public {
    uint256 epoch = dao.epoch();

    // Fill in gaps so APR target is correct
    _fillInEpochGaps(epoch);

    if (epoch > _activeEpoch) {
      for (uint256 i = _activeEpoch; i < epoch; i = i + 1) {
        (uint256 desiredAPR,) = getTargets(i, smoothingPeriod);

        if (epochAPR(i) < desiredAPR) {
          uint256 underflow = _getRewardUnderflow(desiredAPR, i);

          if (underflow > 0) {
            uint256 balance = overflowPool.requestCapital(underflow);

            _sendToDistributor(balance, i);
          }
        } 
      }
    }
  }