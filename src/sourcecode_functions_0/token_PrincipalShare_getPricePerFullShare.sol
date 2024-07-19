function getPricePerFullShare() external override returns (uint256) {
        return pool.pricePerPrincipalShare();
    }