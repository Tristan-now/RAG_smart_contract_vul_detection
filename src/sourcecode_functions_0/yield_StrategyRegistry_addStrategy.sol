function addStrategy(address _strategy) external override onlyOwner {
        require(strategies.length + 1 <= maxStrategies, 'SR:AS1');
        require(registry[_strategy] == 0, 'SR:AS2');
        require(_strategy != address(0), 'SR:AS3');
        registry[_strategy] = 1;
        strategies.push(_strategy);

        emit StrategyAdded(_strategy);
    }