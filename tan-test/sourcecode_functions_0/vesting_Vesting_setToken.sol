function setToken(address _newToken) external override onlyOwner {
    token = IERC20(_newToken);
  }