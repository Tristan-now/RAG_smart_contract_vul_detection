function yieldTokenInPeg( address token, uint256 amount, mapping(address => uint256) storage yieldQuotientsFP, bool forceCurBlock ) internal returns (uint256) {
    uint256 yieldFP = Lending(lending()).viewBorrowingYieldFP(token);
    uint256 amountInToken = (amount * yieldFP) / yieldQuotientsFP[token];
    return PriceAware.getCurrentPriceInPeg(token, amountInToken, forceCurBlock);
}