function totalBalanceOf(address account) external view returns (uint256 balance) {
    AccountInfo storage accountInfo = accountToInfo[account];
    balance = accountInfo.freedBalance;

    // Total ETH cannot realistically overflow 96 bits and escrowIndex will always be < 256 bits.
    unchecked {
      // Add all lockups
      for (uint256 escrowIndex = accountInfo.lockupStartIndex; ; ++escrowIndex) {
        LockedBalance.Lockup memory escrow = accountInfo.lockups.get(escrowIndex);
        if (escrow.expiration == 0) {
          break;
        }
        balance += escrow.totalAmount;
      }
    }
  }