function getTotalUnmintedSherX(IERC20 _token) public view returns (uint256 sherX) {
    PoolStorage.Base storage ps = PoolStorage.ps(_token);
    SherXStorage.Base storage sx = SherXStorage.sx();
    sherX = block.number.sub(ps.sherXLastAccrued).mul(sx.sherXPerBlock).mul(ps.sherXWeight).div(
      uint16(-1)
    );
  }