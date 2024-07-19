function cancelLimitOrder(
        uint256 _id,
        address _trader
    )
        external
    {
        _validateProxy(_trader);
        _checkOwner(_id, _trader);
        IPosition.Trade memory _trade = position.trades(_id);
        if (_trade.orderType == 0) revert();
        IStable(_trade.tigAsset).mintFor(_trader, _trade.margin);
        position.burn(_id);
        emit LimitCancelled(_id, _trader);
    }