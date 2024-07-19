function totalUnderlying() public view override returns (uint256) {
        IVault vault = getVault();
        uint256 balanceUnderlying = _getBalanceUnderlying();
        if (address(vault) == address(0)) {
            return balanceUnderlying;
        }
        uint256 investedUnderlying = vault.getTotalUnderlying();
        return investedUnderlying + balanceUnderlying;
    }