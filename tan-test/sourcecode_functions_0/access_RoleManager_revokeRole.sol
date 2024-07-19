function revokeRole(bytes32 role, address account) public onlyGovernance {
        require(role != Roles.GOVERNANCE, Error.CANNOT_REVOKE_ROLE);
        require(hasRole(role, account), Error.INVALID_ARGUMENT);
        _revokeRole(role, account);
    }