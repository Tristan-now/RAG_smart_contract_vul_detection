    function veCRVlock() external {
        require(lockCrv, "!lock");
        updateFee();
        _buyCRV();
        _lockCRV();
        veCRVShare = 0;
    }

    function _buyCRV() internal {
        IUSDM usdm = engine.usdm();
        address[] memory path = new address[](2);
        path[0] = address(usdm);
        path[1] = address(crv);
        usdm.approve(address(uniswapRouter), veCRVShare);
        uniswapRouter.swapExactTokensForTokens(
            veCRVShare,
            1,
            path,
            address(this),
            type(uint256).max
        );
    }