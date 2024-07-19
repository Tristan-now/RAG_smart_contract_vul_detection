function _transfer(address from, address to, uint256 value) internal override {
    require(block.timestamp > timelock[from], "User locked");
    super._transfer(from, to, value);

    int256 _magCorrection = magnifiedRewardPerShare.mul(value).toInt256();
    magnifiedRewardCorrections[from] = magnifiedRewardCorrections[from].add(_magCorrection);
    magnifiedRewardCorrections[to] = magnifiedRewardCorrections[to].sub(_magCorrection);
  }