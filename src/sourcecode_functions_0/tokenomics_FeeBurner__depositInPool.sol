function _depositInPool(address underlying_, ILiquidityPool pool_)
        internal
        returns (uint256 received)
    {
        // Handling ETH deposits
        if (underlying_ == address(0)) {
            uint256 ethBalance_ = address(this).balance;
            return pool_.deposit{value: ethBalance_}(ethBalance_);
        }

        // Handling ERC20 deposits
        _approve(underlying_, address(pool_));
        return pool_.deposit(IERC20(underlying_).balanceOf(address(this)));
    }