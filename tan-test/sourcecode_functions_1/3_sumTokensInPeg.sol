function sumTokensInPeg( address[] storage tokens, mapping(address => uint256) storage amounts, bool forceCurBlock ) internal returns (uint256 totalPeg) {
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