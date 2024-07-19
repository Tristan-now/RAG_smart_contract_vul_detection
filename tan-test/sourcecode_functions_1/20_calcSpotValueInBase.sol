function calcSpotValueInBase( address token, uint amount ) external view returns (uint value) {
    address pool = getPool(token);
    return calcSpotValueInBaseWithPool(pool, amount);
}