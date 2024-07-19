function _mintInternal(address to, bool calculateFromBase, uint256 fyTokenToBuy, uint256 minTokensMinted)
        internal
        returns (uint256, uint256, uint256)
    {
        // Gather data
        uint256 supply = _totalSupply;
        (uint112 _baseCached, uint112 _fyTokenCached) =
            (baseCached, fyTokenCached);
        uint256 _realFYTokenCached = _fyTokenCached - supply;    // The fyToken cache includes the virtual fyToken, equal to the supply

        // Calculate trade
        uint256 tokensMinted;
        uint256 baseIn;
        uint256 baseReturned;
        uint256 fyTokenIn;

        if (supply == 0) {
            require (calculateFromBase && fyTokenToBuy == 0, "Pool: Initialize only from base");
            baseIn = base.balanceOf(address(this)) - _baseCached;
            tokensMinted = baseIn;   // If supply == 0 we are initializing the pool and tokensMinted == baseIn; fyTokenIn == 0
        } else {
            // There is an optional virtual trade before the mint
            uint256 baseToSell;
            if (fyTokenToBuy > 0) {     // calculateFromBase == true and fyTokenToBuy > 0 can't happen in this implementation. To implement a virtual trade and calculateFromBase the trade would need to be a BaseToBuy parameter.
                baseToSell = _buyFYTokenPreview(
                    fyTokenToBuy.u128(),
                    _baseCached,
                    _fyTokenCached
                ); 
            }

            if (calculateFromBase) {   // We use all the available base tokens, surplus is in fyTokens
                baseIn = base.balanceOf(address(this)) - _baseCached;
                tokensMinted = (supply * baseIn) / _baseCached;
                fyTokenIn = (_realFYTokenCached * tokensMinted) / supply;
                require(_realFYTokenCached + fyTokenIn <= fyToken.balanceOf(address(this)), "Pool: Not enough fyToken in");
            } else {                   // We use all the available fyTokens, plus a virtual trade if it happened, surplus is in base tokens
                fyTokenIn = fyToken.balanceOf(address(this)) - _realFYTokenCached;
                tokensMinted = (supply * (fyTokenToBuy + fyTokenIn)) / (_realFYTokenCached - fyTokenToBuy);
                baseIn = baseToSell + ((_baseCached + baseToSell) * tokensMinted) / supply;
                uint256 _baseBalance = base.balanceOf(address(this));
                require(_baseBalance - _baseCached >= baseIn, "Pool: Not enough base token in");
                
                // If we did a trade means we came in through `mintWithBase`, and want to return the base token surplus
                if (fyTokenToBuy > 0) baseReturned = (_baseBalance - _baseCached) - baseIn;
            }
        }

        // Slippage
        require (tokensMinted >= minTokensMinted, "Pool: Not enough tokens minted");

        // Update TWAR
        _update(
            (_baseCached + baseIn).u128(),
            (_fyTokenCached + fyTokenIn + tokensMinted).u128(), // Account for the "virtual" fyToken from the new minted LP tokens
            _baseCached,
            _fyTokenCached
        );

        // Execute mint
        _mint(to, tokensMinted);

        // Return any unused base if we did a trade, meaning slippage was involved.
        if (supply > 0 && fyTokenToBuy > 0) base.safeTransfer(to, baseReturned);

        emit Liquidity(maturity, msg.sender, to, -(baseIn.i256()), -(fyTokenIn.i256()), tokensMinted.i256());
        return (baseIn, fyTokenIn, tokensMinted);
    }