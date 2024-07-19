function _onlyShutdown() private view {
        require(isShutdown(), "Powered: is not shutdown");
    }