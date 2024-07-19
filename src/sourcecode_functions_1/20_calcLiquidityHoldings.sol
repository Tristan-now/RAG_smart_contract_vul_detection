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