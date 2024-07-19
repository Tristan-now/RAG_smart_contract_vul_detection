function pricePerShare() override public view returns (uint) {
        uint _totalSupply = IERC20(address(bBTC)).totalSupply().add(accumulatedFee);
        if (_totalSupply > 0) {
            return totalSystemAssets().mul(1e18).div(_totalSupply);
        }
        return 1e18;
    }