/// @dev go through list of tokens and their amounts, summing up
function sumTokensInPeg(
    address[] storage tokens,
    mapping(address => uint256) storage amounts,
    bool forceCurBlock
) internal returns (uint256 totalPeg) {
    uint256 len = tokens.length;
    for (uint256 tokenId; tokenId < len; tokenId++) {
        address token = tokens[tokenId];
        totalPeg += PriceAware.getCurrentPriceInPeg(
            token,
            amounts[token],
            forceCurBlock
        );
    }
}

/// @dev calculate yield for token amount and convert to reference currency
function yieldTokenInPeg(
    address token,
    uint256 amount,
    mapping(address => uint256) storage yieldQuotientsFP,
    bool forceCurBlock
) internal returns (uint256) {
    uint256 yieldFP = Lending(lending()).viewBorrowingYieldFP(token);
    uint256 amountInToken = (amount * yieldFP) / yieldQuotientsFP[token];
    return PriceAware.getCurrentPriceInPeg(token, amountInToken, forceCurBlock);
}

/// Get current price of token in peg
function getCurrentPriceInPeg(
    address token,
    uint256 inAmount,
    bool forceCurBlock
) public returns (uint256) {
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

/// @dev retrieves the price from the AMM
function getPriceFromAMM(
    address token,
    uint256 inAmount
) internal virtual returns (uint256) {
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

function _setPriceVal(
    TokenPrice storage tokenPrice,
    uint256 inAmount,
    uint256 outAmount,
    uint256 weightPerMil
) internal {
    uint256 updatePer1k = (1000 ether * inAmount) / (outAmount + 1);
    tokenPrice.tokenPer1k =
        (tokenPrice.tokenPer1k *
            (1000 - weightPerMil) +
            updatePer1k *
            weightPerMil) /
        1000;
}
