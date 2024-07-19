function _createRedemptionInfo(
        ISetToken _setToken,
        address _reserveAsset,
        uint256 _setTokenQuantity
    )
        internal
        view
        returns (ActionInfo memory)
    {
        ActionInfo memory redeemInfo;

        redeemInfo.setTokenQuantity = _setTokenQuantity;

        redeemInfo.preFeeReserveQuantity =_getRedeemReserveQuantity(_setToken, _reserveAsset, _setTokenQuantity);

        (redeemInfo.protocolFees, redeemInfo.managerFee, redeemInfo.netFlowQuantity) = _getFees(
            _setToken,
            redeemInfo.preFeeReserveQuantity,
            PROTOCOL_REDEEM_MANAGER_REVENUE_SHARE_FEE_INDEX,
            PROTOCOL_REDEEM_DIRECT_FEE_INDEX,
            MANAGER_REDEEM_FEE_INDEX
        );

        redeemInfo.previousSetTokenSupply = _setToken.totalSupply();

        (redeemInfo.newSetTokenSupply, redeemInfo.newPositionMultiplier) = _getRedeemPositionMultiplier(_setToken, _setTokenQuantity, redeemInfo);

        redeemInfo.newReservePositionUnit = _getRedeemPositionUnit(_setToken, _reserveAsset, redeemInfo);

        return redeemInfo;
    }