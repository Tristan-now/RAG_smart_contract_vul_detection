function updateScalingPriceOracle(IScalingPriceOracle newScalingPriceOracle)
        external
        override
        onlyOwner
    {
        IScalingPriceOracle oldScalingPriceOracle = scalingPriceOracle;
        scalingPriceOracle = newScalingPriceOracle;

        emit ScalingPriceOracleUpdate(
            oldScalingPriceOracle,
            newScalingPriceOracle
        );
    }