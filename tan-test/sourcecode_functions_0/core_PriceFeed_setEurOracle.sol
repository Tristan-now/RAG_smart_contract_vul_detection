function setEurOracle(address _oracle) public override onlyManager {
    require(_oracle != address(0));
    eurOracle = AggregatorV3Interface(_oracle);
    emit EurOracleUpdated(_oracle, msg.sender);
  }