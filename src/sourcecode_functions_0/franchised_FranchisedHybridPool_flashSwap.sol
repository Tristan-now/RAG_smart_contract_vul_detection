function flashSwap(bytes calldata data) public override lock returns (uint256 amountOut) {
        (address tokenIn, address recipient, bool unwrapBento, uint256 amountIn, bytes memory context) = abi.decode(
            data,
            (address, address, bool, uint256, bytes)
        );
        if (level2) _checkWhiteList(recipient);
        (uint256 _reserve0, uint256 _reserve1) = _getReserves();
        address tokenOut;
        uint256 fee;

        if (tokenIn == token0) {
            tokenOut = token1;
            amountIn = _toAmount(token0, amountIn);
            fee = (amountIn * swapFee) / MAX_FEE;
            amountOut = _getAmountOut(amountIn - fee, _reserve0, _reserve1, true);
            _processSwap(token1, recipient, amountOut, context, unwrapBento);
            uint256 balance0 = _toAmount(token0, __balance(token0));
            require(balance0 - _reserve0 >= amountIn, "INSUFFICIENT_AMOUNT_IN");
        } else {
            require(tokenIn == token1, "INVALID_INPUT_TOKEN");
            tokenOut = token0;
            amountIn = _toAmount(token1, amountIn);
            fee = (amountIn * swapFee) / MAX_FEE;
            amountOut = _getAmountOut(amountIn - fee, _reserve0, _reserve1, false);
            _processSwap(token0, recipient, amountOut, context, unwrapBento);
            uint256 balance1 = _toAmount(token1, __balance(token1));
            require(balance1 - _reserve1 >= amountIn, "INSUFFICIENT_AMOUNT_IN");
        }
        _transfer(tokenIn, fee, barFeeTo, false);
        _updateReserves();
        emit Swap(recipient, tokenIn, tokenOut, amountIn, amountOut);
    }