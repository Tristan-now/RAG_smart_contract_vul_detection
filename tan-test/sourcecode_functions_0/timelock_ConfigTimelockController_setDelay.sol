function setDelay(bytes32 _protocolValue, uint256 _newDelay)
        external
        onlyRole(EXECUTOR_ROLE)
    {
        // Delays must be greater than or equal to the minimum delay
        delays[_protocolValue] = _newDelay >= minDelay ? _newDelay : minDelay;
    }