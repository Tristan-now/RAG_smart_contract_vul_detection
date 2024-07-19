function calcRiskExposure(SystemState calldata sysState)
        external
        view
        override
        returns (ExposureState memory expState)
    {
        expState = _calcRiskExposure(sysState, true);

        // Establish if any stablecoin/protocol is over exposed
        (expState.stablecoinExposed, expState.protocolExposed) = isExposed(
            sysState.rebalanceThreshold,
            expState.stablecoinExposure,
            expState.protocolExposure,
            expState.curveExposure
        );
    }