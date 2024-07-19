function exitZcTokenFillingZcTokenInitiate(Hash.Order calldata o, uint256 a, Sig.Components calldata c) internal {
    bytes32 hash = validOrderHash(o, c);

    require(a <= (o.premium - filled[hash]), 'taker amount > available volume');

    filled[hash] += a;       

    uint256 principalFilled = (((a * 1e18) / o.premium) * o.principal) / 1e18;
    uint256 fee = ((principalFilled * 1e18) / fenominator[1]) / 1e18;

    Erc20 uToken = Erc20(o.underlying);
    // transfer underlying from initiating party to exiting party, minus the price the exit party pays for the exit (premium), and the fee.
    uToken.transferFrom(o.maker, msg.sender, principalFilled - a - fee);
    // transfer fee in underlying to swivel
    uToken.transferFrom(o.maker, address(this), fee);

    // transfer <principalFilled> zcTokens from msg.sender to o.maker
    require(MarketPlace(marketPlace).p2pZcTokenExchange(o.underlying, o.maturity, msg.sender, o.maker, principalFilled), 'zcToken exchange failed');
    
    emit Exit(o.key, hash, o.maker, o.vault, o.exit, msg.sender, a, principalFilled);
  }