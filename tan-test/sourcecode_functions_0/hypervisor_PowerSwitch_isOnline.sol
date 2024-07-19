function isOnline() external view override returns (bool status) {
        return _status == State.Online;
    }