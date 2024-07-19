function getPendingETHGain(address _user) external view override returns (uint) {
         return _getPendingETHGain(_user);
     }