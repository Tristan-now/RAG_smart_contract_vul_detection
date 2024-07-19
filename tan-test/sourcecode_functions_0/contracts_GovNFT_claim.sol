function claim(address _tigAsset) external {
        address _msgsender = _msgSender();
        uint256 amount = pending(_msgsender, _tigAsset);
        userPaid[_msgsender][_tigAsset] += amount;
        IERC20(_tigAsset).transfer(_msgsender, amount);
    }