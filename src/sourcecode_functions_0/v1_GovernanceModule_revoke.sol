function revoke(
        ISetToken _setToken,
        string memory _governanceName
    )
        external
        nonReentrant
        onlyManagerAndValidSet(_setToken)
    {
        IGovernanceAdapter governanceAdapter = IGovernanceAdapter(getAndValidateAdapter(_governanceName));

        (
            address targetExchange,
            uint256 callValue,
            bytes memory methodData
        ) = governanceAdapter.getRevokeCalldata();

        _setToken.invoke(targetExchange, callValue, methodData);

        emit RegistrationRevoked(_setToken, governanceAdapter);
    }