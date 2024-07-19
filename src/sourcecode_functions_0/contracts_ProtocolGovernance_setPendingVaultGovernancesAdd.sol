function setPendingVaultGovernancesAdd(address[] calldata addresses) external {
        require(isAdmin(msg.sender), ExceptionsLibrary.ADMIN);
        _pendingVaultGovernancesAdd = addresses;
        pendingVaultGovernancesAddTimestamp = block.timestamp + params.governanceDelay;
    }