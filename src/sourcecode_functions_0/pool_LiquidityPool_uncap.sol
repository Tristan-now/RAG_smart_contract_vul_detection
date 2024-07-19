function uncap() external override onlyGovernance returns (bool) {
        require(isCapped(), Error.NOT_CAPPED);

        depositCap = 0;
        return true;
    }