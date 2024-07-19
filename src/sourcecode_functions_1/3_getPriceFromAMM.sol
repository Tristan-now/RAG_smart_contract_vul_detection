function getPriceFromAMM( address token, uint256 inAmount ) internal virtual returns (uint256) {
    if (token == peg) {
        return inAmount;
    } else {
        TokenPrice storage tokenPrice = tokenPrices[token];
        uint256[] memory pathAmounts = UniswapStyleLib.getAmountsOut(
            inAmount,
            tokenPrice.liquidationPairs,
            tokenPrice.liquidationTokens
        );
        uint256 outAmount = pathAmounts[pathAmounts.length - 1];

        if (
            outAmount > UPDATE_MIN_PEG_AMOUNT &&
            outAmount < UPDATE_MAX_PEG_AMOUNT
        ) {
            setPriceVal(tokenPrice, inAmount, outAmount);
        }

        return outAmount;
    }
}