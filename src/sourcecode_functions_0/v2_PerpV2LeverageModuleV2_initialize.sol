function initialize(
        ISetToken _setToken
    )
        public
        virtual
        onlySetManager(_setToken, msg.sender)
        onlyValidAndPendingSet(_setToken)
        onlyAllowedSet(_setToken)
    {
        // Initialize module before trying register
        _setToken.initializeModule();

        // Get debt issuance module registered to this module and require that it is initialized
        require(_setToken.isInitializedModule(
            getAndValidateAdapter(DEFAULT_ISSUANCE_MODULE_NAME)),
            "Issuance not initialized"
        );

        // Try if register exists on any of the modules including the debt issuance module
        address[] memory modules = _setToken.getModules();
        for(uint256 i = 0; i < modules.length; i++) {
            try IDebtIssuanceModule(modules[i]).registerToIssuanceModule(_setToken) {
                // This module registered itself on `modules[i]` issuance module.
            } catch {
                // Try will fail if `modules[i]` is not an instance of IDebtIssuanceModule and does not
                // implement the `registerToIssuanceModule` function, or if the `registerToIssuanceModule`
                // function call reverted. Irrespective of the reason for failure, continue to the next module.
            }
        }
    }