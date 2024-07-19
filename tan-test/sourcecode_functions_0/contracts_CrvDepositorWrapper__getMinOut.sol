function _getMinOut(uint256 amount, uint256 minOutBps) internal view returns (uint256) {
        // Gets the balancer time weighted average price denominated in BAL
        // e.g.  if 1 BAL == 0.4 BPT, bptOraclePrice == 2.5
        uint256 bptOraclePrice = _getBptPrice();
        // e.g. minOut = (((100e18 * 1e18) / 2.5e18) * 9980) / 10000;
        // e.g. minout = 39.92e18
        uint256 minOut = (((amount * 1e18) / bptOraclePrice) * minOutBps) / 10000;
        return minOut;
    }