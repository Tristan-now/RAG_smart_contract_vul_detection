function setAddresses(
        address _troveManagerAddress,
        address _activePoolAddress,
        address _defaultPoolAddress,
        address _stabilityPoolAddress,
        address _gasPoolAddress,
        address _collSurplusPoolAddress,
        address _sortedTrovesAddress,
        address _yusdTokenAddress,
        address _sYETIAddress,
        address _whitelistAddress
    ) external override onlyOwner {
        // This makes impossible to open a trove with zero withdrawn YUSD
        require(MIN_NET_DEBT != 0, "BO:MIN_NET_DEBT==0");

        deploymentTime = block.timestamp;

        checkContract(_troveManagerAddress);
        checkContract(_activePoolAddress);
        checkContract(_defaultPoolAddress);
        checkContract(_stabilityPoolAddress);
        checkContract(_gasPoolAddress);
        checkContract(_collSurplusPoolAddress);
        checkContract(_sortedTrovesAddress);
        checkContract(_yusdTokenAddress);
        checkContract(_sYETIAddress);
        checkContract(_whitelistAddress);

        troveManager = ITroveManager(_troveManagerAddress);
        activePool = IActivePool(_activePoolAddress);
        defaultPool = IDefaultPool(_defaultPoolAddress);
        whitelist = IWhitelist(_whitelistAddress);
        stabilityPoolAddress = _stabilityPoolAddress;
        gasPoolAddress = _gasPoolAddress;
        collSurplusPool = ICollSurplusPool(_collSurplusPoolAddress);
        sortedTroves = ISortedTroves(_sortedTrovesAddress);
        yusdToken = IYUSDToken(_yusdTokenAddress);
        sYETIAddress = _sYETIAddress;

        emit TroveManagerAddressChanged(_troveManagerAddress);
        emit ActivePoolAddressChanged(_activePoolAddress);
        emit DefaultPoolAddressChanged(_defaultPoolAddress);
        emit StabilityPoolAddressChanged(_stabilityPoolAddress);
        emit GasPoolAddressChanged(_gasPoolAddress);
        emit CollSurplusPoolAddressChanged(_collSurplusPoolAddress);
        emit SortedTrovesAddressChanged(_sortedTrovesAddress);
        emit YUSDTokenAddressChanged(_yusdTokenAddress);
        emit SYETIAddressChanged(_sYETIAddress);

        _renounceOwnership();
    }