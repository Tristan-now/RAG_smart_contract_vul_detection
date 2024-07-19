function _initializeMixinLockCore(
    address payable _beneficiary,
    uint _expirationDuration,
    uint _keyPrice,
    uint _maxNumberOfKeys
  ) internal
  {
    require(_expirationDuration <= 100 * 365 * 24 * 60 * 60, 'MAX_EXPIRATION_100_YEARS');
    unlockProtocol = IUnlock(msg.sender); // Make sure we link back to Unlock's smart contract.
    beneficiary = _beneficiary;
    expirationDuration = _expirationDuration;
    keyPrice = _keyPrice;
    maxNumberOfKeys = _maxNumberOfKeys;
  }