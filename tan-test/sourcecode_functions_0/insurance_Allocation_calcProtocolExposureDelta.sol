function calcProtocolExposureDelta(uint256[] memory protocolExposure, SystemState memory sysState)
        private
        pure
        returns (uint256 protocolExposedDeltaUsd, uint256 protocolExposedIndex)
    {
        for (uint256 i = 0; i < protocolExposure.length; i++) {
            // If the exposure is greater than the rebalance threshold...
            if (protocolExposedDeltaUsd == 0 && protocolExposure[i] > sysState.rebalanceThreshold) {
                // ...Calculate the delta between exposure and target
                uint256 target = sysState.rebalanceThreshold.sub(sysState.targetBuffer);
                protocolExposedDeltaUsd = protocolExposure[i].sub(target).mul(sysState.totalCurrentAssetsUsd).div(
                    PERCENTAGE_DECIMAL_FACTOR
                );
                protocolExposedIndex = i;
            }
        }
    }