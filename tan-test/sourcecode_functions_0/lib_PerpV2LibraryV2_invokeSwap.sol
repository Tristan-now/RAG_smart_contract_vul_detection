function invokeSwap(
        ISetToken _setToken,
        IQuoter _quoter,
        IQuoter.SwapParams memory _params
    )
        public
        returns (IQuoter.SwapResponse memory)
    {
        ( , , bytes memory swapCalldata) = getSwapCalldata(
            _quoter,
            _params
        );

        bytes memory returnValue = _setToken.invoke(address(_quoter), 0, swapCalldata);
        return abi.decode(returnValue, (IQuoter.SwapResponse));
    }