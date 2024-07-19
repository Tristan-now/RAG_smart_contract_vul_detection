function _getDefaultTradeInfo(ISetToken _setToken, IERC20 _component, bool calculateTradeDirection)
        internal
        view
        returns (TradeInfo memory tradeInfo)
    {
        tradeInfo.setToken = _setToken;
        tradeInfo.setTotalSupply = _setToken.totalSupply();
        tradeInfo.exchangeAdapter = _getExchangeAdapter(_setToken, _component);
        tradeInfo.exchangeData = executionInfo[_setToken][_component].exchangeData;

        if(calculateTradeDirection){
            (
                tradeInfo.isSendTokenFixed,
                tradeInfo.totalFixedQuantity
            ) = _calculateTradeSizeAndDirection(_setToken, _component, tradeInfo.setTotalSupply);
        }

        if (tradeInfo.isSendTokenFixed){
            tradeInfo.sendToken = address(_component);
            tradeInfo.receiveToken = address(weth);
        } else {
            tradeInfo.sendToken = address(weth);
            tradeInfo.receiveToken = address(_component);
        }

        tradeInfo.preTradeSendTokenBalance = IERC20(tradeInfo.sendToken).balanceOf(address(_setToken));
        tradeInfo.preTradeReceiveTokenBalance = IERC20(tradeInfo.receiveToken).balanceOf(address(_setToken));
    }