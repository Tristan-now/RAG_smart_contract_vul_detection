function swapTokenUsingAdapter(uint256 _amount) external {
        IERC20(oldToken).safeTransferFrom(msg.sender, address(this), _amount);
        ITokenSwap(tokenSwap).swapToken();
        IERC20(newToken).safeTransfer(msg.sender, _amount);
    }