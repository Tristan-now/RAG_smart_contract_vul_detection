function getPoolDetails(IOpenLev openLev, uint16[] calldata marketIds, LPoolInterface[] calldata pools) external view returns (PoolVars[] memory results){
        results = new PoolVars[](pools.length);
        for (uint i = 0; i < pools.length; i++) {
            LPoolInterface pool = pools[i];
            IOpenLev.MarketVar memory market = openLev.markets(marketIds[i]);
            PoolVars memory item;
            item.insurance = address(market.pool0) == address(pool) ? market.pool0Insurance : market.pool1Insurance;
            item.cash = pool.getCash();
            item.totalBorrows = pool.totalBorrowsCurrent();
            item.totalReserves = pool.totalReserves();
            item.availableForBorrow = pool.availableForBorrow();
            item.supplyRatePerBlock = pool.supplyRatePerBlock();
            item.borrowRatePerBlock = pool.borrowRatePerBlock();
            item.reserveFactorMantissa = pool.reserveFactorMantissa();
            item.exchangeRate = pool.exchangeRateStored();
            item.baseRatePerBlock = pool.baseRatePerBlock();
            item.multiplierPerBlock = pool.multiplierPerBlock();
            item.jumpMultiplierPerBlock = pool.jumpMultiplierPerBlock();
            item.kink = pool.kink();
            results[i] = item;
        }
        return results;
    }