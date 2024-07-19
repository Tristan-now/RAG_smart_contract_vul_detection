function setRaiseTargetPercentage(
        ISetToken _setToken,
        uint256 _raiseTargetPercentage
    )
        external
        onlyManagerAndValidSet(_setToken)
    {
        require(_raiseTargetPercentage > 0, "Target percentage must be > 0");
        rebalanceInfo[_setToken].raiseTargetPercentage = _raiseTargetPercentage;
        emit RaiseTargetPercentageUpdated(_setToken, _raiseTargetPercentage);
    }