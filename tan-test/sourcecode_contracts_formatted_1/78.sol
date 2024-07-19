  /**
  *@notice takes in a stablecoin, mints flan and pyroFlan and pairs with stablecoin in a Uniswap Pair to generate liquidity
   *@param stablecoin Stablecoin with which to purchase
   *@param amount amount in stablecoin wei units.
   */
  function purchasePyroFlan(address stablecoin, uint256 amount) external {
    uint normalizedAmount = normalize(stablecoin, amount);
    address flanLP = config.flanLPs[stablecoin];
    address pyroFlanLP = config.pyroFlanLPs[stablecoin];
    require(flanLP != address(0) && pyroFlanLP != address(0), "BACKSTOP: configure stablecoin");

    uint256 balanceOfFlanBefore = IERC20(config.flan).balanceOf(flanLP);
    uint256 balanceOfStableBefore = IERC20(stablecoin).balanceOf(flanLP);
    uint256 priceBefore = (balanceOfFlanBefore * getMagnitude(stablecoin)) / balanceOfStableBefore;

    //Price tilt pairs and mint liquidity
    FlanLike(config.flan).mint(address(this), normalizedAmount / 2);
    IERC20(config.flan).transfer(flanLP, normalizedAmount / 4);
    IERC20(stablecoin).transferFrom(msg.sender, flanLP, amount / 2);

    UniPairLike(flanLP).mint(address(this));
    uint256 redeemRate = PyroTokenLike(config.pyroFlan).redeemRate();
    PyroTokenLike(config.pyroFlan).mint(pyroFlanLP, normalizedAmount / 4);
    redeemRate = PyroTokenLike(config.pyroFlan).redeemRate();
    redeemRate = PyroTokenLike(config.pyroFlan).redeemRate();
    IERC20(stablecoin).transferFrom(msg.sender, pyroFlanLP, amount / 2);
    UniPairLike(pyroFlanLP).mint(address(this));

    uint256 balanceOfFlan = IERC20(config.flan).balanceOf(flanLP);
    uint256 balanceOfStable = IERC20(stablecoin).balanceOf(flanLP);

    uint256 tiltedPrice = (balanceOfFlan * getMagnitude(stablecoin)) / balanceOfStable;
    require(tiltedPrice < config.acceptableHighestPrice[stablecoin], "BACKSTOP: potential price manipulation");
    uint256 growth = ((priceBefore - tiltedPrice) * 100) / priceBefore;

    uint256 flanToMint = (tiltedPrice * normalizedAmount) / (1 ether);

    //share some price tilting with the user to incentivize minting: The larger the purchase, the better the return
    uint256 premium = (flanToMint * (growth / 2)) / 100;

    FlanLike(config.flan).mint(address(this), flanToMint + premium);
    redeemRate = PyroTokenLike(config.pyroFlan).redeemRate();
    PyroTokenLike(config.pyroFlan).mint(msg.sender, flanToMint + premium);
    redeemRate = PyroTokenLike(config.pyroFlan).redeemRate();
  }
