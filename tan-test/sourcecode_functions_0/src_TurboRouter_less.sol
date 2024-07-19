function less(TurboSafe safe, ERC4626 vault, uint256 feiAmount) external authenticate(address(safe)) {
        safe.less(vault, feiAmount);
    }