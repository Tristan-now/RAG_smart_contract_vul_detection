function setMintFee(uint256 newMintFeeBasisPoints)
        external
        override
        hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.PARAMETER_ADMIN)
    {
        _setMintFee(newMintFeeBasisPoints);
    }