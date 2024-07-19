function createMarket(string memory _tokenNameSuffix, string memory _tokenSymbolSuffix, bytes32 longTokenSalt, bytes32 shortTokenSalt, address _governance, address _collateral, uint256 _floorLongPrice, uint256 _ceilingLongPrice, uint256 _floorValuation, uint256 _ceilingValuation, uint256 _expiryTime) external override onlyOwner nonReentrant {
    require(validCollateral[_collateral], "Invalid collateral");

    (LongShortToken _longToken, LongShortToken _shortToken) = _createPairTokens(_tokenNameSuffix, _tokenSymbolSuffix, longTokenSalt, shortTokenSalt);
    bytes32 _salt = keccak256(abi.encodePacked(_longToken, _shortToken));

    PrePOMarket _newMarket = new PrePOMarket{salt: _salt}(_governance, _collateral, ILongShortToken(address(_longToken)), ILongShortToken(address(_shortToken)), _floorLongPrice, _ceilingLongPrice, _floorValuation, _ceilingValuation, _expiryTime);
    deployedMarkets[_salt] = address(_newMarket);

    _longToken.transferOwnership(address(_newMarket));
    _shortToken.transferOwnership(address(_newMarket));
    emit MarketAdded(address(_newMarket), _salt);
  }