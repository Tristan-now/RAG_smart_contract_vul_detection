function deposit(uint256 _amount)
        external
        nonReentrant
        noContractAllowed
        expectInitialized
    {
        require(!emergencyExit, 'emergency pause enabled');

        CDP.Data storage _cdp = _cdps[msg.sender];
        _cdp.update(_ctx);

        token.safeTransferFrom(msg.sender, address(this), _amount);
        if (_amount >= flushActivator) {
            flushActiveVault();
        }
        totalDeposited = totalDeposited.add(_amount);

        _cdp.totalDeposited = _cdp.totalDeposited.add(_amount);
        _cdp.lastDeposit = block.number;

        emit TokensDeposited(msg.sender, _amount);
    }