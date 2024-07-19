function getPricePerFullShareStored() external view override returns (uint256) {
        return pool.pricePerPrincipalShareStored();
    }