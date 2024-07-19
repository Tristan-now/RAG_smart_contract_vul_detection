function lockBasketData(uint256 _block) internal {
        basket.singleCall(
            address(basket),
            abi.encodeWithSelector(basket.setLock.selector, _block),
            0
        );
    }