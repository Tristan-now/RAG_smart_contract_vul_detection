function _distributeFees(uint256 amount) internal virtual {
        // Mint fees directly to the distributor and distribute.
        if (amount > 0) {
            address feeReceiver = vaultFactory.feeReceiver();
            _mint(feeReceiver, amount);
            INFTXFeeDistributor(feeReceiver).distribute(vaultId);
        }
    }