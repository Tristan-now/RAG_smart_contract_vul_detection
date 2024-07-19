function calculateRemoveLiquidityOneToken(
        address account,
        uint256 tokenAmount,
        uint8 tokenIndex
    ) external view returns (uint256 availableTokenAmount) {
        (availableTokenAmount, ) = swapStorage.calculateWithdrawOneToken(
            account,
            tokenAmount,
            tokenIndex
        );
    }