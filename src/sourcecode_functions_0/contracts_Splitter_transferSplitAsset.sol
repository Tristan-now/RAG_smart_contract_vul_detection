function transferSplitAsset(address to, uint256 value)
        private
        returns (bool didSucceed)
    {
        // Try to transfer ETH to the given recipient.
        didSucceed = IERC20(splitAsset).transfer(to, value);
        require(didSucceed, "Failed to transfer ETH");

        emit TransferETH(to, value, didSucceed);
    }