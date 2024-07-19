function sendToSYETI(address _sender, uint256 _amount) external override {
        _requireCallerIsSYETI();
        if (_isFirstYear()) { _requireSenderIsNotMultisig(_sender); }  // Prevent the multisig from staking YETI
        _transfer(_sender, sYETIAddress, _amount);
    }