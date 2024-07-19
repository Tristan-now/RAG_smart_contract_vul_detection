function removeFromWhitelist(address _address) 
    public
    onlyRole(ADMIN_ROLE, "Must have admin role")  
  {
    if (!whitelist[_address]) {
      return;
    }
    whitelist[_address] = false;
    emit RemoveFromWhitelist(_address);
  }