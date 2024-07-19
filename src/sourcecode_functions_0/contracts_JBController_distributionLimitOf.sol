function distributionLimitOf(
    uint256 _projectId,
    uint256 _configuration,
    IJBPaymentTerminal _terminal,
    address _token
  ) external view override returns (uint256, uint256) {
    // Get a reference to the packed data.
    uint256 _data = _packedDistributionLimitDataOf[_projectId][_configuration][_terminal][_token];

    // The limit is in bits 0-231. The currency is in bits 232-255.
    return (uint256(uint232(_data)), _data >> 232);
  }