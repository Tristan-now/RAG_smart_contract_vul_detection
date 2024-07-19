    function addQuote(uint256 baseTokenAmount, uint256 fractionalTokenAmount) public view returns (uint256) {
        uint256 lpTokenSupply = lpToken.totalSupply();
        if (lpTokenSupply > 0) {
            // calculate amount of lp tokens as a fraction of existing reserves
            uint256 baseTokenShare = (baseTokenAmount * lpTokenSupply) / baseTokenReserves();
            uint256 fractionalTokenShare = (fractionalTokenAmount * lpTokenSupply) / fractionalTokenReserves();
            return Math.min(baseTokenShare, fractionalTokenShare);
        } else {
            // if there is no liquidity then init
            return Math.sqrt(baseTokenAmount * fractionalTokenAmount);
        }
    }

    function add(uint256 baseTokenAmount, uint256 fractionalTokenAmount, uint256 minLpTokenAmount)
        public
        payable
        returns (uint256 lpTokenAmount)
    {
        // *** Checks *** //

        // check the token amount inputs are not zero
        require(baseTokenAmount > 0 && fractionalTokenAmount > 0, "Input token amount is zero");

        // check that correct eth input was sent - if the baseToken equals address(0) then native ETH is used
        require(baseToken == address(0) ? msg.value == baseTokenAmount : msg.value == 0, "Invalid ether input");

        // calculate the lp token shares to mint
        lpTokenAmount = addQuote(baseTokenAmount, fractionalTokenAmount);

        // check that the amount of lp tokens outputted is greater than the min amount
        require(lpTokenAmount >= minLpTokenAmount, "Slippage: lp token amount out");

        // *** Effects *** //

        // transfer fractional tokens in
        _transferFrom(msg.sender, address(this), fractionalTokenAmount);

        // *** Interactions *** //

        // mint lp tokens to sender
        lpToken.mint(msg.sender, lpTokenAmount);

        // transfer base tokens in if the base token is not ETH
        if (baseToken != address(0)) {
            // transfer base tokens in
            ERC20(baseToken).safeTransferFrom(msg.sender, address(this), baseTokenAmount);
        }

        emit Add(baseTokenAmount, fractionalTokenAmount, lpTokenAmount);
    }