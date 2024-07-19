function _calculateSymbol(IERC20Extended token)
        internal
        view
        returns (string memory)
    {
        return _combine(token.symbol(), ".s");
    }