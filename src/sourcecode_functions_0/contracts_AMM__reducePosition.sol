function _reducePosition(address trader, int256 baseAssetQuantity, uint quoteAssetLimit)
        internal
        returns (int realizedPnl, uint256 quoteAsset)
    {
        (, int256 unrealizedPnl) = getTakerNotionalPositionAndUnrealizedPnl(trader);

        Position storage position = positions[trader]; // storage because there are updates at the end
        bool isLongPosition = position.size > 0 ? true : false;

        if (isLongPosition) {
            longOpenInterestNotional -= (-baseAssetQuantity).toUint256();
            quoteAsset = _short(baseAssetQuantity, quoteAssetLimit);
        } else {
            shortOpenInterestNotional -= baseAssetQuantity.toUint256();
            quoteAsset = _long(baseAssetQuantity, quoteAssetLimit);
        }
        uint256 notionalPosition = getCloseQuote(position.size + baseAssetQuantity);
        (position.openNotional, realizedPnl) = getOpenNotionalWhileReducingPosition(position.size, notionalPosition, unrealizedPnl, baseAssetQuantity);
        position.size += baseAssetQuantity;
    }