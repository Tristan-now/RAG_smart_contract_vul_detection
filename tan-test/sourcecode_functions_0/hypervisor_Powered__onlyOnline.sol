function _onlyOnline() private view {
        require(isOnline(), "Powered: is not online");
    }