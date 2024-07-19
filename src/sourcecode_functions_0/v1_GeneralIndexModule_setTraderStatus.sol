function setTraderStatus(
        ISetToken _setToken,
        address[] memory _traders,
        bool[] memory _statuses
    )
        external
        onlyManagerAndValidSet(_setToken)
    {
        _traders.validatePairsWithArray(_statuses);

        for (uint256 i = 0; i < _traders.length; i++) {
            _updateTradersHistory(_setToken, _traders[i], _statuses[i]);
            permissionInfo[_setToken].tradeAllowList[_traders[i]] = _statuses[i];
            emit TraderStatusUpdated(_setToken, _traders[i], _statuses[i]);
        }
    }