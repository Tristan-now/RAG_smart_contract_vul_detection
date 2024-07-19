function revokeOverride(bytes32 role, address account)
        external
        override
        onlyGuardian
    {
        require(
            role != GOVERN_ROLE,
            "Permissions: Guardian cannot revoke governor"
        );

        // External call because this contract is appointed as a governor and has access to revoke
        this.revokeRole(role, account);
    }