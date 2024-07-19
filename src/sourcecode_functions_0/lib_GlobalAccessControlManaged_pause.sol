function pause() external {
        require(gac.hasRole(PAUSER_ROLE, msg.sender));
        _pause();
    }