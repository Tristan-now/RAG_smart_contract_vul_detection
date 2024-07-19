function fetchPricePoint () public view override returns (
        PricePoint memory price_
    ) {

        int56[] memory _ticks;
        uint160[] memory _liqs;

        uint _ovlPrice;
        uint _marketLiquidity;

        int24 _microTick;
        int24 _macroTick;

        {

            uint32[] memory _secondsAgo = new uint32[](3);
            _secondsAgo[2] = uint32(macroWindow);
            _secondsAgo[1] = uint32(microWindow);

            ( _ticks, _liqs ) = IUniswapV3Pool(marketFeed).observe(_secondsAgo);

            _macroTick = int24(( _ticks[0] - _ticks[2]) / int56(int32(int(macroWindow))));

            _microTick = int24((_ticks[0] - _ticks[1]) / int56(int32(int(microWindow))));

            uint _sqrtPrice = TickMath.getSqrtRatioAtTick(_microTick);

            uint _liquidity = (uint160(microWindow) << 128) / ( _liqs[0] - _liqs[1] );

            _marketLiquidity = ethIs0
                ? ( uint256(_liquidity) << 96 ) / _sqrtPrice
                : FullMath.mulDiv(uint256(_liquidity), _sqrtPrice, X96);

        }


        {

            uint32[] memory _secondsAgo = new uint32[](2);

            _secondsAgo[1] = uint32(macroWindow);

            ( _ticks, ) = IUniswapV3Pool(ovlFeed).observe(_secondsAgo);

            _ovlPrice = OracleLibraryV2.getQuoteAtTick(
                int24((_ticks[0] - _ticks[1]) / int56(int32(int(macroWindow)))),
                1e18,
                ovl,
                eth
            );

        }

        price_ = PricePoint(
            _microTick, 
            _macroTick, 
            computeDepth(_marketLiquidity, _ovlPrice)
        );

    }