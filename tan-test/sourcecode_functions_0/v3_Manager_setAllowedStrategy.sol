function setAllowedStrategy(
        address _strategy,
        bool _allowed
    )
        external
        notHalted
        onlyGovernance
    {
        require(address(IStrategy(_strategy).manager()) == address(this), "!manager");
        allowedStrategies[_strategy] = _allowed;
        emit AllowedStrategy(_strategy, _allowed);
    }