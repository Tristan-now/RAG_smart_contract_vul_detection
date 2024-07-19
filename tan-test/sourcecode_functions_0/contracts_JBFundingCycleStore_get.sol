function get(uint256 _projectId, uint256 _configuration)
    external
    view
    override
    returns (JBFundingCycle memory fundingCycle)
  {
    return _getStructFor(_projectId, _configuration);
  }