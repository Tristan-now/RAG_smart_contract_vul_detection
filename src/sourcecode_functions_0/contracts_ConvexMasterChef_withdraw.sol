function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        uint256 pending = user.amount.mul(pool.accCvxPerShare).div(1e12).sub(
            user.rewardDebt
        );
        safeRewardTransfer(msg.sender, pending);
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(pool.accCvxPerShare).div(1e12);
        pool.lpToken.safeTransfer(address(msg.sender), _amount);

        //extra rewards
        IRewarder _rewarder = pool.rewarder;
        if (address(_rewarder) != address(0)) {
            _rewarder.onReward(_pid, msg.sender, msg.sender, pending, user.amount);
        }

        emit RewardPaid(msg.sender, _pid, pending);
        emit Withdraw(msg.sender, _pid, _amount);
    }