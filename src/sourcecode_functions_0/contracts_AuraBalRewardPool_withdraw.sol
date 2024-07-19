function withdraw(
        uint256 amount,
        bool claim,
        bool lock
    ) public updateReward(msg.sender) returns (bool) {
        require(amount > 0, "RewardPool : Cannot withdraw 0");

        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);

        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);

        if (claim) {
            getReward(lock);
        }

        return true;
    }