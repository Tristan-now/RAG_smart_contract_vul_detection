function removeSet(address _setToken) external onlyInitialized onlyOwner {
        require(isSet[_setToken], "Set does not exist");

        sets = sets.remove(_setToken);

        isSet[_setToken] = false;

        emit SetRemoved(_setToken);
    }