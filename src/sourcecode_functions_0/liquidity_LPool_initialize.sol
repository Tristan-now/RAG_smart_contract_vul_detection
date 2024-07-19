function initialize(
        address underlying_,
        bool isWethPool_,
        address controller_,
        uint256 baseRatePerBlock_,
        uint256 multiplierPerBlock_,
        uint256 jumpMultiplierPerBlock_,
        uint256 kink_,
        uint initialExchangeRateMantissa_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_) public {
        require(underlying_ != address(0), "underlying_ address cannot be 0");
        require(controller_ != address(0), "controller_ address cannot be 0");
        require(msg.sender == admin, "Only allow to be called by admin");
        require(accrualBlockNumber == 0 && borrowIndex == 0, "inited once");

        // Set initial exchange rate
        initialExchangeRateMantissa = initialExchangeRateMantissa_;
        require(initialExchangeRateMantissa > 0, "Initial Exchange Rate Mantissa should be greater zero");
        //set controller
        controller = controller_;
        isWethPool = isWethPool_;
        //set interestRateModel
        baseRatePerBlock = baseRatePerBlock_;
        multiplierPerBlock = multiplierPerBlock_;
        jumpMultiplierPerBlock = jumpMultiplierPerBlock_;
        kink = kink_;

        // Initialize block number and borrow index (block number mocks depend on controller being set)
        accrualBlockNumber = getBlockNumber();
        borrowIndex = 1e25;
        //80%
        borrowCapFactorMantissa = 0.8e18;
        //10%
        reserveFactorMantissa = 0.1e18;


        name = name_;
        symbol = symbol_;
        decimals = decimals_;

        _notEntered = true;

        // Set underlying and sanity check it
        underlying = underlying_;
        IERC20(underlying).totalSupply();
        emit Transfer(address(0), msg.sender, 0);
    }