function _calculateFee(uint256 amount, uint256 feeBps)
        internal
        pure
        returns (uint256)
    {
        if (feeBps == 0) {
            return 0;
        }
        uint256 fee = (amount * feeBps) / MAX_BPS;
        return fee;
    }