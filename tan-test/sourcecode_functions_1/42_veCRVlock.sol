function veCRVlock() external {
        require(lockCrv, "!lock");
        updateFee();
        _buyCRV();
        _lockCRV();
        veCRVShare = 0;
    }