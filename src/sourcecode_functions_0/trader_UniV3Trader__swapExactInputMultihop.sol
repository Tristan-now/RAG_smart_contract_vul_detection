function _swapExactInputMultihop(
        uint256 amount,
        address recipient,
        PathItem[] memory path,
        Options memory options
    ) internal returns (uint256 amountOut) {
        address input = path[0].token0;
        ISwapRouter.ExactInputParams memory params = ISwapRouter.ExactInputParams({
            path: _makeMultihopPath(path),
            recipient: recipient,
            deadline: options.deadline,
            amountIn: amount,
            amountOutMinimum: options.limitAmount
        });
        IERC20(input).safeTransferFrom(msg.sender, address(this), amount);
        _approveERC20TokenIfNecessary(input, address(swapRouter));
        amountOut = swapRouter.exactInput(params);
    }