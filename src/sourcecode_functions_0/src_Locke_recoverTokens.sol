function recoverTokens(address token, address recipient) public lock {
        // NOTE: it is the stream creators responsibility to save
        // tokens on behalf of their users.
        require(msg.sender == streamCreator, "!creator");
        if (token == depositToken) {
            require(block.timestamp > endDepositLock, "time");
            // get the balance of this contract
            // check what isnt claimable by either party
            uint256 excess = ERC20(token).balanceOf(address(this)) - (depositTokenAmount - redeemedDepositTokens);
            // allow saving of the token
            ERC20(token).safeTransfer(recipient, excess);

            emit RecoveredTokens(token, recipient, excess);
            return;
        }
        
        if (token == rewardToken) {
            require(block.timestamp > endRewardLock, "time");
            // check current balance vs internal balance
            //
            // NOTE: if a token rebases, i.e. changes balance out from under us,
            // most of this contract breaks and rugs depositors. this isn't exclusive
            // to this function but this function would in theory allow someone to rug
            // and recover the excess (if it is worth anything)

            // check what isnt claimable by depositors and governance
            uint256 excess = ERC20(token).balanceOf(address(this)) - (rewardTokenAmount + rewardTokenFeeAmount);
            ERC20(token).safeTransfer(recipient, excess);

            emit RecoveredTokens(token, recipient, excess);
            return;
        }

        if (incentives[token] > 0) {
            require(block.timestamp >= endStream, "stream");
            uint256 excess = ERC20(token).balanceOf(address(this)) - incentives[token];
            ERC20(token).safeTransfer(recipient, excess);
            emit RecoveredTokens(token, recipient, excess);
            return;
        }

        // not reward token nor deposit nor incentivized token, free to transfer
        uint256 bal = ERC20(token).balanceOf(address(this));
        ERC20(token).safeTransfer(recipient, bal);
        emit RecoveredTokens(token, recipient, bal);
    }