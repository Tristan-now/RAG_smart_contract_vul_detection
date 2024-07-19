function setUniswapFeedAddress(
        address token1,
        address token2,
        address pool
    ) external onlyOwner {
        require(token1 != token2, 'PO:SUFA1');
        bytes32 _poolTokensId = getUniswapPoolTokenId(token1, token2);
        uniswapPools[_poolTokensId] = pool;
        emit UniswapFeedUpdated(token1, token2, _poolTokensId, pool);
    }