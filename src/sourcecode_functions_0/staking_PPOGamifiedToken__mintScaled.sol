function _mintScaled(address _account, uint256 _amount) private {
    emit Transfer(address(0), _account, _amount);

    _afterTokenTransfer(address(0), _account, _amount);
  }