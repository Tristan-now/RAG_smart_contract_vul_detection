function _executeSwaps(LiFiData memory _lifiData, LibSwap.SwapData[] calldata _swapData) internal {
        // Swap
        for (uint8 i; i < _swapData.length; i++) {
            require(
                ls.dexWhitelist[_swapData[i].approveTo] == true && ls.dexWhitelist[_swapData[i].callTo] == true,
                "Contract call not allowed!"
            );

            LibSwap.swap(_lifiData.transactionId, _swapData[i]);
        }
    }