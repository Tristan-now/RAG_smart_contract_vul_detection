function initialize(ISetToken _setToken) external onlySetManager(_setToken, msg.sender) onlyValidAndPendingSet(_setToken) {
        _setToken.initializeModule();
    }