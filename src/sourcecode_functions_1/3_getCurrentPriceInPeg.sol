function getCurrentPriceInPeg( address token, uint256 inAmount, bool forceCurBlock ) public returns (uint256) {
    TokenPrice storage tokenPrice = tokenPrices[token];
    if (forceCurBlock) {
        if (block.number - tokenPrice.blockLastUpdated > priceUpdateWindow) {
            // update the currently cached price
            return getPriceFromAMM(token, inAmount);
        } else {
            // just get the current price from AMM
            return viewCurrentPriceInPeg(token, inAmount);
        }
    } else if (tokenPrice.tokenPer1k == 0) {
        // do the best we can if it's at zero
        return getPriceFromAMM(token, inAmount);
    }

    if (block.number - tokenPrice.blockLastUpdated > priceUpdateWindow) {
        // update the price somewhat
        getPriceFromAMM(token, inAmount);
    }

    return (inAmount * 1000 ether) / tokenPrice.tokenPer1k;
}