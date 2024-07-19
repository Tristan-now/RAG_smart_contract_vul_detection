function hook(
    address _from,
    address _to,
    uint256 _amount
  ) public virtual override(BlocklistTransferHook, ITransferHook) {
    super.hook(_from, _to, _amount);
    if (sourceAllowlist.isIncluded(_from)) return;
    require(destinationAllowlist.isIncluded(_to), "Destination not allowed");
  }