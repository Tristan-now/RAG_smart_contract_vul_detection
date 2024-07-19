function setAddresses(
        address _borrowerOperationsAddress,
        address _troveManagerAddress,
        address _activePoolAddress,
        address _yusdTokenAddress,
        address _sortedTrovesAddress,
        address _communityIssuanceAddress,
        address _whitelistAddress,
        address _troveManagerLiquidationsAddress
    ) external override onlyOwner {
        checkContract(_borrowerOperationsAddress);
        checkContract(_troveManagerAddress);
        checkContract(_activePoolAddress);
        checkContract(_yusdTokenAddress);
        checkContract(_sortedTrovesAddress);
        checkContract(_communityIssuanceAddress);
        checkContract(_whitelistAddress);
        checkContract(_troveManagerLiquidationsAddress);

        borrowerOperations = IBorrowerOperations(_borrowerOperationsAddress);
        troveManager = ITroveManager(_troveManagerAddress);
        activePool = IActivePool(_activePoolAddress);
        yusdToken = IYUSDToken(_yusdTokenAddress);
        sortedTroves = ISortedTroves(_sortedTrovesAddress);
        communityIssuance = ICommunityIssuance(_communityIssuanceAddress);
        whitelist = IWhitelist(_whitelistAddress);

        troveManagerLiquidationsAddress = _troveManagerLiquidationsAddress;
        whitelistAddress = _whitelistAddress;

        emit BorrowerOperationsAddressChanged(_borrowerOperationsAddress);
        emit TroveManagerAddressChanged(_troveManagerAddress);
        emit ActivePoolAddressChanged(_activePoolAddress);
        emit YUSDTokenAddressChanged(_yusdTokenAddress);
        emit SortedTrovesAddressChanged(_sortedTrovesAddress);
        emit CommunityIssuanceAddressChanged(_communityIssuanceAddress);

        _renounceOwnership();
    }