function cycleWithWbtc(uint poolId, uint idx, uint amount) external {
        wbtc.safeTransferFrom(msg.sender, address(this), amount);
        wbtc.approve(address(zap), amount);
        uint _ibbtc = zap.mint(wbtc, amount, poolId, idx, 0);
        _redeem(_ibbtc, msg.sender);
    }