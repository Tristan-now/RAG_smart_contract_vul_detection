function deposit(Liquidity calldata _deposits) external {
    Liquidity memory total = totalLiquidity;
    Liquidity memory user = userLiquidity[msg.sender];
    if (_deposits.usdm > 0) {
        usdm.safeTransferFrom(
            msg.sender,
            address(this),
            uint256(_deposits.usdm)
        );
        total.usdm += _deposits.usdm;
        user.usdm += _deposits.usdm;
    }

    if (_deposits.pool3 > 0) {
        require(totalLiquidity.usdm > 4000000e18, "usdm low");
        pool3.safeTransferFrom(
            msg.sender,
            address(this),
            uint256(_deposits.pool3)
        );
        total.pool3 += _deposits.pool3;
        user.pool3 += _deposits.pool3;
    }
    totalLiquidity = total;
    userLiquidity[msg.sender] = user;
    emit Deposit(msg.sender, _deposits);
}

function withdraw(Liquidity calldata _withdrawal) external {
    Liquidity memory total = totalLiquidity;
    Liquidity memory user = userLiquidity[msg.sender];
    if (_withdrawal.usdm > 0) {
        require(unlockable, "!unlock usdm");
        usdm.safeTransfer(msg.sender, uint256(_withdrawal.usdm));
        total.usdm -= _withdrawal.usdm;
        user.usdm -= _withdrawal.usdm;
    }

    if (_withdrawal.pool3 > 0) {
        pool3.safeTransfer(msg.sender, uint256(_withdrawal.pool3));
        total.pool3 -= _withdrawal.pool3;
        user.pool3 -= _withdrawal.pool3;
    }
    totalLiquidity = total;
    userLiquidity[msg.sender] = user;
    emit Withdraw(msg.sender, _withdrawal);
}

function provide(uint256 _minimumLP) external onlyGuardian {
    require(usdm.balanceOf(address(this)) >= totalLiquidity.usdm, "<liquidity");
    // truncate amounts under step
    uint256 addingLiquidity = (usdm.balanceOf(address(this)) / step) * step;
    // match usdm : pool3 = 1 : 1
    uint256[2] memory amounts = [addingLiquidity, addingLiquidity];
    usdm.approve(address(usdm3crv), addingLiquidity);
    pool3.approve(address(usdm3crv), addingLiquidity);
    usdm3crv.add_liquidity(amounts, _minimumLP);
}

function removeLiquidity( uint256 _steps, uint256 _burningLPs ) external onlyGuardian {
    uint256 removingLiquidity = _steps * step;
    uint256[2] memory amounts = [removingLiquidity, removingLiquidity];
    usdm3crv.remove_liquidity(_burningLPs, amounts);
}
