function getSettlementPriceWithDecimals(
        address _oracle,
        address _asset,
        uint256 _expiryTimestamp
    )
        external
        view
        override
        returns (PriceWithDecimals memory settlementPrice)
    {
        settlementPrice = _settlementPrices[_oracle][_asset][_expiryTimestamp];
        require(
            settlementPrice.price != 0,
            "PriceRegistry: No settlement price has been set"
        );
    }