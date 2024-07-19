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