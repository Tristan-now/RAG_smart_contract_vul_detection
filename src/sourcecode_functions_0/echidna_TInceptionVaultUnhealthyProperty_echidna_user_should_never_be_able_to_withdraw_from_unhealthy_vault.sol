function echidna_user_should_never_be_able_to_withdraw_from_unhealthy_vault() public returns (bool) {
    require(_inceptionVaultsDataProvider.vaultDebt(1) > 0);
    try _inceptionVaultsCore.withdraw(_TEST_VAULT_ID, 1)  {
      return false;
    } catch {
      return true;
    }
  }