function updatePricePerShare() public virtual returns (uint256) {
        pricePerShare = core.pricePerShare();
        lastPricePerShareUpdate = now;

        emit SetPricePerShare(pricePerShare, lastPricePerShareUpdate);
    }