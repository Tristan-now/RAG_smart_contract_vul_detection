function _getStorageSlot(StorageId storageId)
        private
        pure
        returns (uint256 slot)
    {
        // This should never overflow with a reasonable `STORAGE_SLOT_EXP`
        // because Solidity will do a range check on `storageId` during the cast.
        return uint256(storageId) + STORAGE_SLOT_BASE;
    }