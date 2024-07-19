function hookERC1155(
    address _user,
    address _tokenContract,
    uint256 _tokenId,
    uint256 _amount
  ) external view override {
    ITokenShop _shop = tokenShop;
    require(address(_shop) != address(0), "Token shop not set in hook");
    uint256 _maxPurchaseAmount = erc1155ToIdToMaxPurchasesPerUser[
      _tokenContract
    ][_tokenId];
    if (_maxPurchaseAmount != 0) {
      require(
        _shop.getERC1155PurchaseCount(_user, _tokenContract, _tokenId) +
          _amount <=
          _maxPurchaseAmount,
        "ERC1155 purchase limit reached"
      );
    }
  }