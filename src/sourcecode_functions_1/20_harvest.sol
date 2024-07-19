function harvest() public override {
    address router = abi.decode(
        IAdapter(address(this)).strategyConfig(),
        (address)
    );
    address asset = IAdapter(address(this)).asset();
    address[] memory rewardTokens = IWithRewards(address(this)).rewardTokens();

    IWithRewards(address(this)).claim(); // hook to accrue/pull in rewards, if needed

    address[] memory tradePath = new address[](2);
    tradePath[1] = asset;

    uint256 len = rewardTokens.length;
    // send all tokens to destination
    for (uint256 i = 0; i < len; i++) {
        uint256 amount = ERC20(rewardTokens[i]).balanceOf(address(this));

        if (amount > 0) {
            tradePath[0] = rewardTokens[i];

            IUniswapRouterV2(router).swapExactTokensForTokens(
                amount,
                0,
                tradePath,
                address(this),
                block.timestamp
            );
        }
    }
    IAdapter(address(this)).strategyDeposit(
        ERC20(asset).balanceOf(address(this)),
        0
    );
}