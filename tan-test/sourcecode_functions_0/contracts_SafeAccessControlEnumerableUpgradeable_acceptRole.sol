function acceptRole(bytes32 _role) public virtual override {
    require(_roleToAccountToNominated[_role][_msgSender()], "msg.sender != role nominee");
    _setRoleNominee(_role, _msgSender(), false);
    _grantRole(_role, _msgSender());
  }