function setAddresses(
        address _sortedTrovesAddress,
        address _troveManagerAddress,
        address _whitelistAddress
    )
        external
        onlyOwner
    {
        checkContract(_sortedTrovesAddress);
        checkContract(_troveManagerAddress);
        checkContract(_whitelistAddress);

        sortedTroves = ISortedTroves(_sortedTrovesAddress);
        troveManager = ITroveManager(_troveManagerAddress);
        whitelist = IWhitelist(_whitelistAddress);

        emit SortedTrovesAddressChanged(_sortedTrovesAddress);
        emit TroveManagerAddressChanged(_troveManagerAddress);
        emit WhitelistAddressChanged(_troveManagerAddress);

        _renounceOwnership();
    }