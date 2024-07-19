function getCollateralToken(
        address _underlyingAsset,
        address _oracle,
        address _qTokenAsCollateral,
        uint256 _strikePrice,
        uint256 _expiryTime,
        bool _isCall
    ) external view override returns (uint256) {
        address qToken = getQToken(
            _underlyingAsset,
            _oracle,
            _strikePrice,
            _expiryTime,
            _isCall
        );

        uint256 id = collateralToken.getCollateralTokenId(
            qToken,
            _qTokenAsCollateral
        );

        (address storedQToken, ) = collateralToken.idToInfo(id);
        return storedQToken != address(0) ? id : 0;
    }