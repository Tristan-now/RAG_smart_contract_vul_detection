function provide(uint256 _minimumLP) external onlyGuardian {
    require(usdm.balanceOf(address(this)) >= totalLiquidity.usdm, "<liquidity");
    // truncate amounts under step
    uint256 addingLiquidity = (usdm.balanceOf(address(this)) / step) * step;
    // match usdm : pool3 = 1 : 1
    uint256[2] memory amounts = [addingLiquidity, addingLiquidity];
    usdm.approve(address(usdm3crv), addingLiquidity);
    pool3.approve(address(usdm3crv), addingLiquidity);
    usdm3crv.add_liquidity(amounts, _minimumLP);
}