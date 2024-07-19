function setMinActiveBalance(uint256 _minActiveBalance) external override onlyOwner {
    // New value cannot be the same as current value
    if (minActiveBalance == _minActiveBalance) revert InvalidArgument();
    // Can't set a value that is too high to be reasonable
    if (_minActiveBalance >= MIN_BALANCE_SANITY_CEILING) revert InvalidConditions();

    emit MinBalance(minActiveBalance, _minActiveBalance);
    minActiveBalance = _minActiveBalance;
  }