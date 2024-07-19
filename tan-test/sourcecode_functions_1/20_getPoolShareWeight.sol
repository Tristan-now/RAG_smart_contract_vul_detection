function getPoolShareWeight( address token, uint units ) external view returns (uint weight) {
    address pool = getPool(token);
    weight = calcShare(
        units,
        iBEP20(pool).totalSupply(),
        iPOOL(pool).baseAmount()
    );
    return (weight);
}