function addToken(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public  {
        require(
            hasAdminRole(msg.sender),
            "MasterChef.addToken: Sender must be admin"
        );
        if (_withUpdate) {
            massUpdatePools();
        }
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolInfo.push(PoolInfo({
            lpToken: _lpToken,
            allocPoint: _allocPoint,
            lastRewardBlock: lastRewardBlock,
            accRewardsPerShare: 0
        }));
    }