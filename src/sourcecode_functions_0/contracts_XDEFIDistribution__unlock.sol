function _unlock(address account_, uint256 tokenId_) internal returns (uint256 amountUnlocked_) {
        // Check that the account is the position NFT owner.
        require(ownerOf(tokenId_) == account_, "NOT_OWNER");

        // Fetch position.
        Position storage position = positionOf[tokenId_];
        uint96 units = position.units;
        uint88 depositedXDEFI = position.depositedXDEFI;
        uint32 expiry = position.expiry;

        // Check that enough time has elapsed in order to unlock.
        require(expiry != uint32(0), "NO_LOCKED_POSITION");
        require(block.timestamp >= uint256(expiry), "CANNOT_UNLOCK");

        // Get the withdrawable amount of XDEFI for the position.
        amountUnlocked_ = _withdrawableGiven(units, depositedXDEFI, position.pointsCorrection);

        // Track deposits.
        totalDepositedXDEFI -= uint256(depositedXDEFI);

        // Burn FDT Position.
        totalUnits -= units;
        delete positionOf[tokenId_];

        emit LockPositionWithdrawn(tokenId_, account_, amountUnlocked_);
    }