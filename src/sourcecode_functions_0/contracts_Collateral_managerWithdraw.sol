function managerWithdraw(uint256 _amount) external override onlyRole(MANAGER_WITHDRAW_ROLE) nonReentrant {
    if (address(managerWithdrawHook) != address(0)) managerWithdrawHook.hook(msg.sender, _amount, _amount);
    baseToken.transfer(manager, _amount);
  }