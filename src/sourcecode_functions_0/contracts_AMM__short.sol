function _short(int256 baseAssetQuantity, uint min_dy) internal returns (uint256 quoteAssetQuantity) {
        require(baseAssetQuantity < 0, "VAMM._short: baseAssetQuantity is >= 0");

        uint _lastPrice;
        (quoteAssetQuantity, _lastPrice) = vamm.exchange(
            1, // sell base asset
            0, // get quote asset
            (-baseAssetQuantity).toUint256(), // short exactly. Note that statement asserts that baseAssetQuantity <= 0
            min_dy
        );

        _addReserveSnapshot(_lastPrice);
        // since maker position will be opposite of the trade
        posAccumulator -= baseAssetQuantity * 1e18 / vamm.totalSupply().toInt256();
        emit Swap(baseAssetQuantity, quoteAssetQuantity, _lastPrice, openInterestNotional());
    }