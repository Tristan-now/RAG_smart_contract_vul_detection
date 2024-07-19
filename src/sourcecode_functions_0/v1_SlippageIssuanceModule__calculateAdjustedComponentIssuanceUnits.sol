function _calculateAdjustedComponentIssuanceUnits(
        ISetToken _setToken,
        uint256 _quantity,
        bool _isIssue,
        int256[] memory _equityAdjustments,
        int256[] memory _debtAdjustments
    )
        internal
        view
        returns (address[] memory, uint256[] memory, uint256[] memory)
    {
        (
            address[] memory components,
            uint256[] memory equityUnits,
            uint256[] memory debtUnits
        ) = _getTotalIssuanceUnits(_setToken);

        // NOTE: components.length isn't stored in local variable to avoid stack too deep errors. Since this function is used
        // by view functions intended to be queried off-chain this seems acceptable
        uint256[] memory totalEquityUnits = new uint256[](components.length);
        uint256[] memory totalDebtUnits = new uint256[](components.length);
        for (uint256 i = 0; i < components.length; i++) {
            // NOTE: If equityAdjustment is negative and exceeds equityUnits in absolute value this will revert
            // When adjusting units if we have MORE equity as a result of issuance (ie adjustment is positive) we want to add that
            // to the unadjusted equity units hence we use addition. Vice versa if we want to remove equity, the adjustment is negative
            // hence adding adjusts the units lower
            uint256 adjustedEquityUnits = equityUnits[i].toInt256().add(_equityAdjustments[i]).toUint256();

            // Use preciseMulCeil to round up to ensure overcollateration when small issue quantities are provided
            // and preciseMul to round down to ensure overcollateration when small redeem quantities are provided
            totalEquityUnits[i] = _isIssue ?
                adjustedEquityUnits.preciseMulCeil(_quantity) :
                adjustedEquityUnits.preciseMul(_quantity);

            // NOTE: If debtAdjustment is negative and exceeds debtUnits in absolute value this will revert
            // When adjusting units if we have MORE debt as a result of issuance (ie adjustment is negative) we want to increase
            // the unadjusted debt units hence we subtract. Vice versa if we want to remove debt the adjustment is positive
            // hence subtracting adjusts the units lower.
            uint256 adjustedDebtUnits = debtUnits[i].toInt256().sub(_debtAdjustments[i]).toUint256();

            // Use preciseMulCeil to round up to ensure overcollateration when small redeem quantities are provided
            // and preciseMul to round down to ensure overcollateration when small issue quantities are provided
            totalDebtUnits[i] = _isIssue ?
                adjustedDebtUnits.preciseMul(_quantity) :
                adjustedDebtUnits.preciseMulCeil(_quantity);
        }

        return (components, totalEquityUnits, totalDebtUnits);
    }