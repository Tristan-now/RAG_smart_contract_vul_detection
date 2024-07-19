function setGlobalRateLimitedMinter(GlobalRateLimitedMinter newMinter)
        external
        override
        hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.PSM_ADMIN_ROLE)
    {
        _setGlobalRateLimitedMinter(newMinter);
    }