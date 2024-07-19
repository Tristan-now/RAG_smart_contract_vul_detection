function removeRole(bytes32 role, address _entity)
    external
    onlyRole(TIMELOCK_ROLE, "Only timelock can revoke roles")
  {
    revokeRole(role, _entity);
  }