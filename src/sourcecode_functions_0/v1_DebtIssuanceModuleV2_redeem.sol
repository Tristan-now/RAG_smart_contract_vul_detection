function redeem(
        ISetToken _setToken,
        uint256 _quantity,
        address _to
    )
        external
        override
        nonReentrant
        onlyValidAndInitializedSet(_setToken)
    {
        require(_quantity > 0, "Redeem quantity must be > 0");

        _callModulePreRedeemHooks(_setToken, _quantity);

        uint256 initialSetSupply = _setToken.totalSupply();

        // Place burn after pre-redeem hooks because burning tokens may lead to false accounting of synced positions
        _setToken.burn(msg.sender, _quantity);

        (
            uint256 quantityNetFees,
            uint256 managerFee,
            uint256 protocolFee
        ) = calculateTotalFees(_setToken, _quantity, false);

        // Prevent stack too deep
        {
            (
                address[] memory components,
                uint256[] memory equityUnits,
                uint256[] memory debtUnits
            ) = _calculateRequiredComponentIssuanceUnits(_setToken, quantityNetFees, false);

            uint256 finalSetSupply = initialSetSupply.sub(quantityNetFees);

            _resolveDebtPositions(_setToken, quantityNetFees, false, components, debtUnits, initialSetSupply, finalSetSupply);
            _resolveEquityPositions(_setToken, quantityNetFees, _to, false, components, equityUnits, initialSetSupply, finalSetSupply);
            _resolveFees(_setToken, managerFee, protocolFee);
        }

        emit SetTokenRedeemed(
            _setToken,
            msg.sender,
            _to,
            _quantity,
            managerFee,
            protocolFee
        );
    }