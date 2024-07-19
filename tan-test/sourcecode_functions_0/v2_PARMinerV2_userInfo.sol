function userInfo(address _user) public view override returns (UserInfo memory) {
    return _users[_user];
  }