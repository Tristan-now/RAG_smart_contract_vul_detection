function removeStrategy(
        address _vault,
        address _strategy,
        uint256 _timeout
    )
        external
        override
        onlyController
    {
        uint256 tail = strategies[_vault].addresses.length;
        uint256 index;
        bool found;
        for (uint i; i < tail; i++) {
            if (strategies[_vault].addresses[i] == _strategy) {
                index = i;
                found = true;
                break;
            }
        }

        if (found) {
            strategies[_vault].addresses[index] = strategies[_vault].addresses[tail.sub(1)];
            strategies[_vault].addresses.pop();
            strategies[_vault].timeout = _timeout;
            emit StrategyRemoved(_vault, _strategy, _timeout);
        }
    }