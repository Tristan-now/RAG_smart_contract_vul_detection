function withdraw(
        address,
        uint256 _amount
    )
        external
        onlyEnabledVault
        onlyMetaVault
    {
        uint256 _balance = token.balanceOf(address(this));
        // happy path exits without calling back to the vault
        if (_balance >= _amount) {
            token.safeTransfer(metavault, _amount);
            emit Withdraw(_amount);
        } else {
            uint256 _toWithdraw = _amount.sub(_balance);
            IVault cachedVault = vault;
            // convert to vault shares
            address[] memory _tokens = cachedVault.getTokens();
            require(_tokens.length > 0, "!_tokens");
            // get the amount of the token that we would be withdrawing
            uint256 _expected = converter.expected(address(token), _tokens[0], _toWithdraw);
            uint256 _shares = _expected.mul(1e18).div(cachedVault.getPricePerFullShare());
            cachedVault.withdraw(_shares, _tokens[0]);
            _balance = IERC20(_tokens[0]).balanceOf(address(this));
            IERC20(_tokens[0]).safeTransfer(address(converter), _balance);
            // TODO: calculate expected
            converter.convert(_tokens[0], address(token), _balance, 1);
            emit Withdraw(token.balanceOf(address(this)));
            token.safeTransfer(metavault, token.balanceOf(address(this)));
        }
    }