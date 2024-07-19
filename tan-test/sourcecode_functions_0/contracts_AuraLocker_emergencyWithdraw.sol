function emergencyWithdraw() external nonReentrant {
        require(isShutdown, "Must be shutdown");

        LockedBalance[] memory locks = userLocks[msg.sender];
        Balances storage userBalance = balances[msg.sender];

        uint256 amt = userBalance.locked;
        require(amt > 0, "Nothing locked");

        userBalance.locked = 0;
        userBalance.nextUnlockIndex = locks.length.to32();
        lockedSupply -= amt;

        emit Withdrawn(msg.sender, amt, false);

        stakingToken.safeTransfer(msg.sender, amt);
    }