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