function _getTokenType(string memory symbol) internal view returns (TokenType) {
        return TokenType(getUint(_getTokenTypeKey(symbol)));
    }