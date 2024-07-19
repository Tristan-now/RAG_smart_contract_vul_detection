function acceptRoleAdmin(bytes32 _role) public virtual override onlyRole(_roleToRoleAdminNominee[_role]) {
    _setRoleAdmin(_role, _roleToRoleAdminNominee[_role]);
    _setRoleAdminNominee(_role, 0x00);
  }