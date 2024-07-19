function _stableToLp(uint256[N_COINS] memory tokenAmounts, bool deposit) internal view returns (uint256) {
        require(tokenAmounts.length == N_COINS, "deposit: !length");
        uint256[N_COINS] memory _tokenAmounts;
        for (uint256 i = 0; i < N_COINS; i++) {
            _tokenAmounts[i] = tokenAmounts[i];
        }
        return curvePool.calc_token_amount(_tokenAmounts, deposit);
    }