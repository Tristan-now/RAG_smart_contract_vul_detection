function enableWhitelist() external onlyOwner {
        whitelistEnabled = true;
        emit WhitelistEnabled();
    }