function _redeemToBacking(
        ITempusPool targetPool,
        address sender,
        uint256 principals,
        uint256 yields,
        address recipient
    ) private {
        require((principals > 0) || (yields > 0), "principalAmount and yieldAmount cannot both be 0");

        (uint redeemedYBT, uint redeemedBT, uint fee, uint rate) = targetPool.redeemToBacking(
            sender,
            principals,
            yields,
            recipient
        );

        bool earlyRedeem = !targetPool.matured();
        emit Redeemed(
            address(targetPool),
            sender,
            recipient,
            principals,
            yields,
            redeemedYBT,
            redeemedBT,
            fee,
            rate,
            earlyRedeem
        );
    }