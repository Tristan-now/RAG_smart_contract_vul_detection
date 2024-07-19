function isVaultGovernance(address addr) external view returns (bool) {
        return _vaultGovernances.contains(addr);
    }