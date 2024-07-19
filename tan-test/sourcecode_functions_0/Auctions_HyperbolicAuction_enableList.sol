function enableList(bool _status) external {
        require(hasAdminRole(msg.sender));
        marketStatus.usePointList = _status;
    }