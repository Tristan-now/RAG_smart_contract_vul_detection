function getShareAssets(uint256 shares) public view override returns (uint256) {
        return applyFactor(shares, getPricePerShare(), true);
    }