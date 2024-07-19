function stake(uint256 _amount) public updateReward(msg.sender) returns (bool) {
        require(_amount > 0, "RewardPool : Cannot stake 0");

        _totalSupply = _totalSupply.add(_amount);
        _balances[msg.sender] = _balances[msg.sender].add(_amount);

        stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
        emit Staked(msg.sender, _amount);

        return true;
    }