function _getBestDex(
        address fromToken,
        address toToken,
        uint256 amount
    ) internal view returns (address bestDex, uint256 amountOut) {
        address uniswap_ = UNISWAP;
        address sushiSwap_ = UNISWAP;
        uint256 amountOutUniswap = _tokenAmountOut(fromToken, toToken, amount, uniswap_);
        uint256 amountOutSushiSwap = _tokenAmountOut(fromToken, toToken, amount, sushiSwap_);
        return
            amountOutUniswap >= amountOutSushiSwap
                ? (uniswap_, amountOutUniswap)
                : (sushiSwap_, amountOutSushiSwap);
    }