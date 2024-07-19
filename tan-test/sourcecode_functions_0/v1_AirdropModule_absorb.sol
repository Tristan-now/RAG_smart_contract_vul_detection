function absorb(ISetToken _setToken, IERC20 _token)
        external
        nonReentrant
        onlyValidCaller(_setToken)
        onlyValidAndInitializedSet(_setToken)
    {
        _absorb(_setToken, _token);
    }