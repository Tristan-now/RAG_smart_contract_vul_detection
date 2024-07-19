function swap(uint256 _YUSDAmount, uint256 _minYETIOut, address _to) external override returns (uint256[] memory amounts) {
        address cachedJOERouterAddress = JOERouterAddress;
        IERC20 cachedYUSDToken = yusdToken;
        require(cachedYUSDToken.approve(cachedJOERouterAddress, 0));
        require(cachedYUSDToken.increaseAllowance(cachedJOERouterAddress, _YUSDAmount));
        amounts = JOERouter.swapExactTokensForTokens(_YUSDAmount, _minYETIOut, path, _to, block.timestamp);
    }