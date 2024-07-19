function accountSurplus(
        address _account,
        address[] memory _tokens,
        uint256[] memory _amounts
    ) external override {
        _requireCallerIsTroveManager();
        balances[_account] = _sumColls(balances[_account], _tokens, _amounts);
        emit CollBalanceUpdated(_account);
    }