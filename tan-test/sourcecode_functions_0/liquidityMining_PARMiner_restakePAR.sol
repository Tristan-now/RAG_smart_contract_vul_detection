function restakePAR(address _user) public virtual {
    UserInfo storage userInfo = _users[_user];
    _refresh();
    _refreshPAR(totalStake);
    uint256 pending = userInfo.stake.rayMul(_accParAmountPerShare.sub(userInfo.accParAmountPerShare));
    _parBalanceTracker = _parBalanceTracker.sub(pending);
    userInfo.accParAmountPerShare = _accParAmountPerShare;

    _increaseStake(_user, pending);
  }