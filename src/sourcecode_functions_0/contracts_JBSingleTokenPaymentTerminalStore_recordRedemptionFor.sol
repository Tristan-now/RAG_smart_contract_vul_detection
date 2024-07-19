function recordRedemptionFor(
    address _holder,
    uint256 _projectId,
    uint256 _tokenCount,
    string memory _memo,
    bytes memory _metadata
  )
    external
    override
    nonReentrant
    returns (
      JBFundingCycle memory fundingCycle,
      uint256 reclaimAmount,
      IJBRedemptionDelegate delegate,
      string memory memo
    )
  {
    // Get a reference to the project's current funding cycle.
    fundingCycle = fundingCycleStore.currentOf(_projectId);

    // The current funding cycle must not be paused.
    if (fundingCycle.redeemPaused()) revert FUNDING_CYCLE_REDEEM_PAUSED();

    // Scoped section prevents stack too deep. `_reclaimedTokenAmount`, `_currentOverflow`, and `_totalSupply` only used within scope.
    {
      // Get a reference to the reclaimed token amount struct, the current overflow, and the total token supply.
      JBTokenAmount memory _reclaimedTokenAmount;
      uint256 _currentOverflow;
      uint256 _totalSupply;

      // Another scoped section prevents stack too deep. `_token`, `_decimals`, and `_currency` only used within scope.
      {
        // Get a reference to the terminal's tokens.
        address _token = IJBSingleTokenPaymentTerminal(msg.sender).token();

        // Get a reference to the terminal's decimals.
        uint256 _decimals = IJBSingleTokenPaymentTerminal(msg.sender).decimals();

        // Get areference to the terminal's currency.
        uint256 _currency = IJBSingleTokenPaymentTerminal(msg.sender).currency();

        // Get the amount of current overflow.
        // Use the local overflow if the funding cycle specifies that it should be used. Otherwise, use the project's total overflow across all of its terminals.
        _currentOverflow = fundingCycle.useTotalOverflowForRedemptions()
          ? _currentTotalOverflowOf(_projectId, _decimals, _currency)
          : _overflowDuring(
            IJBSingleTokenPaymentTerminal(msg.sender),
            _projectId,
            fundingCycle,
            _currency
          );

        // Get the number of outstanding tokens the project has.
        _totalSupply = IJBController(directory.controllerOf(_projectId)).totalOutstandingTokensOf(
          _projectId,
          fundingCycle.reservedRate()
        );

        // Can't redeem more tokens that is in the supply.
        if (_tokenCount > _totalSupply) revert INSUFFICIENT_TOKENS();

        if (_currentOverflow > 0)
          // Calculate reclaim amount using the current overflow amount.
          reclaimAmount = _reclaimableOverflowDuring(
            _projectId,
            fundingCycle,
            _tokenCount,
            _totalSupply,
            _currentOverflow
          );

        _reclaimedTokenAmount = JBTokenAmount(_token, reclaimAmount, _decimals, _currency);
      }

      // If the funding cycle has configured a data source, use it to derive a claim amount and memo.
      if (fundingCycle.useDataSourceForRedeem()) {
        // Create the params that'll be sent to the data source.
        JBRedeemParamsData memory _data = JBRedeemParamsData(
          IJBSingleTokenPaymentTerminal(msg.sender),
          _holder,
          _projectId,
          fundingCycle.configuration,
          _tokenCount,
          _totalSupply,
          _currentOverflow,
          _reclaimedTokenAmount,
          fundingCycle.useTotalOverflowForRedemptions(),
          fundingCycle.redemptionRate(),
          fundingCycle.ballotRedemptionRate(),
          _memo,
          _metadata
        );
        (reclaimAmount, memo, delegate) = IJBFundingCycleDataSource(fundingCycle.dataSource())
          .redeemParams(_data);
      } else {
        memo = _memo;
      }
    }

    // The amount being reclaimed must be within the project's balance.
    if (reclaimAmount > balanceOf[IJBSingleTokenPaymentTerminal(msg.sender)][_projectId])
      revert INADEQUATE_PAYMENT_TERMINAL_STORE_BALANCE();

    // Remove the reclaimed funds from the project's balance.
    if (reclaimAmount > 0)
      balanceOf[IJBSingleTokenPaymentTerminal(msg.sender)][_projectId] =
        balanceOf[IJBSingleTokenPaymentTerminal(msg.sender)][_projectId] -
        reclaimAmount;
  }