function whitelistWrapper(address _wrapper) external onlyGovernor {
    whitelistedWrappers[_wrapper] = true;

    emit WrapperWhitelist(_wrapper);
  }