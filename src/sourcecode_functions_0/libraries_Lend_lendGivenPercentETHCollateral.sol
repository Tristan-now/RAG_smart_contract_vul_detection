function lendGivenPercentETHCollateral(
        mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
        IConvenience convenience,
        IFactory factory,
        IWETH weth,
        ILend.LendGivenPercentETHCollateral calldata params
    ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
        (assetIn, claimsOut) = _lendGivenPercent(
            natives,
            ILend._LendGivenPercent(
                convenience,
                factory,
                params.asset,
                weth,
                params.maturity,
                msg.sender,
                params.bondTo,
                params.insuranceTo,
                params.assetIn,
                params.percent,
                params.minBond,
                params.minInsurance,
                params.deadline
            )
        );
    }