function gavg(int128 x, int128 y) internal pure returns (int128) {
    int256 m = int256(x) * int256(y);
    require(m >= 0);
    require(m < 0x4000000000000000000000000000000000000000000000000000000000000000);
    return int128(sqrtu(uint256(m)));
  }