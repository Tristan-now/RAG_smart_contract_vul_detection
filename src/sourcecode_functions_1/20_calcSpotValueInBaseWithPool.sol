function calcSpotValueInBaseWithPool( address pool, uint amount ) public view returns (uint value) {
    uint _baseAmount = iPOOL(pool).baseAmount();
    uint _tokenAmount = iPOOL(pool).tokenAmount();
    return (amount * (_baseAmount)) / (_tokenAmount);
}