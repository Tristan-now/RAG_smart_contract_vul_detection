function _calculateStreamingFee(ISetToken _setToken) internal view returns(uint256) {
        uint256 timeSinceLastFee = block.timestamp.sub(_lastStreamingFeeTimestamp(_setToken));

        // Streaming fee is streaming fee times years since last fee
        return timeSinceLastFee.mul(_streamingFeePercentage(_setToken)).div(ONE_YEAR_IN_SECONDS);
    }