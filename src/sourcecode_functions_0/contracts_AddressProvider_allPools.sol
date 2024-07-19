function allPools() external view override returns (address[] memory) {
        return _tokenToPools.valuesArray();
    }