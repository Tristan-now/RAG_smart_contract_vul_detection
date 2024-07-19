function removeLiquidity( address tokenA, address tokenB, uint256 id, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline ) public override ensure(deadline) returns (uint256 amountA, uint256 amountB) {
        IERC20 _foreignAsset = pool.positionForeignAsset(id);
        IERC20 _nativeAsset = nativeAsset;

        bool isNativeA = _nativeAsset == IERC20(tokenA);

        if (isNativeA) {
            require(
                IERC20(tokenB) == _foreignAsset,
                "VaderRouterV2::removeLiquidity: Incorrect Addresses Specified"
            );
        } else {
            require(
                IERC20(tokenA) == _foreignAsset &&
                    IERC20(tokenB) == _nativeAsset,
                "VaderRouterV2::removeLiquidity: Incorrect Addresses Specified"
            );
        }

        pool.transferFrom(msg.sender, address(pool), id);

        (
            uint256 amountNative,
            uint256 amountForeign,
            uint256 coveredLoss
        ) = pool.burn(id, to);

        (amountA, amountB) = isNativeA
            ? (amountNative, amountForeign)
            : (amountForeign, amountNative);

        require(
            amountA >= amountAMin,
            "VaderRouterV2: INSUFFICIENT_A_AMOUNT"
        );
        require(
            amountB >= amountBMin,
            "VaderRouterV2: INSUFFICIENT_B_AMOUNT"
        );

        reserve.reimburseImpermanentLoss(msg.sender, coveredLoss);
    }