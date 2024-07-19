function _initialSetup(address _rewardToken, address _miningService) internal {
    _roleSetup(MINING_SERVICE_ROLE, _miningService);
    _roleSetup(REWARD_MANAGER_ROLE, _miningService);

    rewardToken = ERC20(_rewardToken);
    miningService = _miningService;
  }