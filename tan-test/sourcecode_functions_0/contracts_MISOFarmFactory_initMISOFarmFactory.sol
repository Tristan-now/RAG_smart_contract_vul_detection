function initMISOFarmFactory(
        address _accessControls,
        address payable _misoDiv,
        uint256 _minimumFee,
        uint256 _integratorFeePct
    )
        external
    {
        /// @dev Maybe missing require message?
        require(!initialised);
        require(_misoDiv != address(0));
        locked = true;
        initialised = true;
        misoDiv = _misoDiv;
        minimumFee = _minimumFee;
        integratorFeePct = _integratorFeePct;
        accessControls = MISOAccessControls(_accessControls);
        emit MisoInitFarmFactory(msg.sender);
    }