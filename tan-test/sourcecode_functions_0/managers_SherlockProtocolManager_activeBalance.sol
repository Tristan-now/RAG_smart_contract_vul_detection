function activeBalance(bytes32 _protocol)
    external
    view
    override
    protocolExists(_protocol)
    returns (uint256)
  {
    return _activeBalance(_protocol);
  }