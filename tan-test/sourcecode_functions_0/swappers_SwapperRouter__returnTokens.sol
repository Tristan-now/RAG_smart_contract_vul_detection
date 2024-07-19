function _returnTokens(address token_, uint256 amount_)
        internal
        returns (uint256 amountReturned)
    {
        // Returning if ETH
        if (token_ == address(0)) {
            payable(msg.sender).transfer(amount_);
            return amount_;
        }

        // Returning if ERC20
        IERC20(token_).safeTransfer(msg.sender, amount_);
        return amount_;
    }