function _onlyGovernor() internal view {
    require(msg.sender == _governor(), "Only governor can execute");
  }