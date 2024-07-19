function redeemToUnderlying(
        uint256 amount,
        address receiver,
        uint32 maxImpliedRate
    ) external override {
        redeem(
            amount,
            RedeemOpts({
                redeemToUnderlying: true,
                transferfCash: false,
                receiver: receiver,
                maxImpliedRate: maxImpliedRate
            })
        );
    }