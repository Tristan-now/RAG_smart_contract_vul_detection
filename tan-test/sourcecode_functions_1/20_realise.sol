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