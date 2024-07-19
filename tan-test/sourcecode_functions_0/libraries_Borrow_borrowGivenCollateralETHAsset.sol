function borrowGivenCollateralETHAsset(
        mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
        IConvenience convenience,
        IFactory factory,
        IWETH weth,
        IBorrow.BorrowGivenCollateralETHAsset calldata params
    )
        external
        returns (
            uint256 assetOut,
            uint256 id,
            IPair.Due memory dueOut
        )
    {
        (assetOut, id, dueOut) = _borrowGivenCollateral(
            natives,
            IBorrow._BorrowGivenCollateral(
                convenience,
                factory,
                weth,
                params.collateral,
                params.maturity,
                msg.sender,
                address(this),
                params.dueTo,
                params.assetOut,
                params.collateralIn,
                params.maxDebt,
                params.deadline
            )
        );

        weth.withdraw(assetOut);
        ETH.transfer(payable(params.assetTo), assetOut);
    }