// Burn LPs to if their value outweights the synths supply value (Ensures incentives are funnelled to existing LPers)
function realise(address pool) external {
    uint baseValueLP = iUTILS(_DAO().UTILS()).calcLiquidityHoldings(
        mapSynth_LPBalance[pool],
        BASE,
        pool
    ); // Get the SPARTA value of the LP tokens
    uint baseValueSynth = iUTILS(_DAO().UTILS()).calcActualSynthUnits(
        mapSynth_LPDebt[pool],
        address(this)
    ); // Get the SPARTA value of the synths
    if (baseValueLP > baseValueSynth) {
        uint premium = baseValueLP - baseValueSynth; // Get the premium between the two values
        if (premium > 10 ** 18) {
            uint premiumLP = iUTILS(_DAO().UTILS()).calcLiquidityUnitsAsym(
                premium,
                pool
            ); // Get the LP value of the premium
            mapSynth_LPBalance[pool] -= premiumLP; // Reduce the LP balance
            Pool(pool).burn(premiumLP); // Burn the premium of the LP tokens
        }
    }
}

function calcLiquidityHoldings( uint units, address token, address pool ) external view returns (uint share) {
    // share = amount * part / total
    // address pool = getPool(token);
    uint amount;
    if (token == BASE) {
        amount = iPOOL(pool).baseAmount();
    } else {
        amount = iPOOL(pool).tokenAmount();
    }
    uint totalSupply = iBEP20(pool).totalSupply();
    return (amount * (units)) / (totalSupply);
}

// Check and record the deposit
function _deposit(address _synth, address _member, uint256 _amount) internal {
    if (!isStakedSynth[_synth]) {
        isStakedSynth[_synth] = true; // Record as a staked synth
        stakedSynthAssets.push(_synth); // Add to staked synth array
    }
    mapMemberSynth_lastTime[_member][_synth] =
        block.timestamp +
        minimumDepositTime; // Record deposit time (scope: member -> synth)
    mapMember_depositTime[_member] = block.timestamp + minimumDepositTime; // Record deposit time (scope: member)
    mapMemberSynth_deposit[_member][_synth] += _amount; // Record balance for member
    uint256 _weight = iUTILS(_DAO().UTILS()).calcSpotValueInBase(
        iSYNTH(_synth).LayerONE(),
        _amount
    ); // Get the SPARTA weight of the deposit
    mapMemberSynth_weight[_member][_synth] += _weight; // Add the weight to the user (scope: member -> synth)
    mapMemberTotal_weight[_member] += _weight; // Add to the user's total weight (scope: member)
    totalWeight += _weight; // Add to the total weight (scope: vault)
    isSynthMember[_member][_synth] = true; // Record user as a member
    emit MemberDeposits(_synth, _member, _amount, _weight, totalWeight);
}
function calcSpotValueInBase( address token, uint amount ) external view returns (uint value) {
    address pool = getPool(token);
    return calcSpotValueInBaseWithPool(pool, amount);
}

function calcSpotValueInBaseWithPool( address pool, uint amount ) public view returns (uint value) {
    uint _baseAmount = iPOOL(pool).baseAmount();
    uint _tokenAmount = iPOOL(pool).tokenAmount();
    return (amount * (_baseAmount)) / (_tokenAmount);
}

/// @notice claim all token rewards and trade them for the underlying asset
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
function getPoolShareWeight( address token, uint units ) external view returns (uint weight) {
    address pool = getPool(token);
    weight = calcShare(
        units,
        iBEP20(pool).totalSupply(),
        iPOOL(pool).baseAmount()
    );
    return (weight);
}
// Calc share | share = amount * part / total
function calcShare( uint256 part, uint256 total, uint256 amount ) public pure returns (uint256 share) {
    if (part > total) {
        part = total; // Part cant be greater than the total
    }
    if (total > 0) {
        share = (amount * part) / total;
    }
}
