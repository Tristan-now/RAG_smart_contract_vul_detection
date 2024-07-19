function setAmmGauge(address token, address _ammGauge)
        external
        override
        onlyGovernance
        returns (bool)
    {
        require(IAmmGauge(_ammGauge).isAmmToken(token), Error.ADDRESS_NOT_WHITELISTED);
        uint256 length = _ammGauges.length();
        for (uint256 i = 0; i < length; i++) {
            if (address(_ammGauges.valueAt(i)) == _ammGauge) {
                return false;
            }
        }
        if (_ammGauges.contains(token)) {
            address ammGauge = _ammGauges.get(token);
            IAmmGauge(ammGauge).poolCheckpoint();
            IAmmGauge(ammGauge).kill();
        }
        _ammGauges.set(token, _ammGauge);
        gauges[_ammGauge] = true;
        return true;
    }