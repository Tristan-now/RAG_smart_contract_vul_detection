function setIsExcludedAddressStatus(address[] memory _addresses, bool[] memory _status) external onlyOwner {
        require(_addresses.length == _status.length, "ERR__LENGTH_MISMATCH");
        for (uint256 i = 0; i < _addresses.length; ++i) {
            isExcludedAddress[_addresses[i]] = _status[i];
            emit ExcludedAddressStatusUpdated(_addresses[i], _status[i]);
        }
    }