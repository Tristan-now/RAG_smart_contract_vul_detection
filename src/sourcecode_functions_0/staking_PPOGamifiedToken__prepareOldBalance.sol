function _prepareOldBalance(address _account)
    private
    returns (Balance memory oldBalance, uint256 oldScaledBalance)
  {
    // Get the old balance
    oldBalance = _balances[_account];
    oldScaledBalance = _scaleBalance(oldBalance);
    // Take the opportunity to check for season finish
    _balances[_account].achievementsMultiplier = achievementsManager
      .checkForSeasonFinish(_account);
  }