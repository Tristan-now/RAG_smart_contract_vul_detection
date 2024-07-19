function updatePrice( uint256 marketPrice, uint256 oraclePrice, bool newRecord ) internal {
        // Price records entries updated every hour
        if (newRecord) {
            // Make new hourly record, total = marketprice, numtrades set to 1;
            Prices.PriceInstant memory newHourly = Prices.PriceInstant(marketPrice, 1);
            hourlyTracerPrices[currentHour] = newHourly;
            // As above but with Oracle price
            Prices.PriceInstant memory oracleHour = Prices.PriceInstant(oraclePrice, 1);
            hourlyOraclePrices[currentHour] = oracleHour;
        } else {
            // If an update is needed, add the market price to a running total and increment number of trades
            hourlyTracerPrices[currentHour].cumulativePrice =
                hourlyTracerPrices[currentHour].cumulativePrice +
                marketPrice;
            hourlyTracerPrices[currentHour].trades = hourlyTracerPrices[currentHour].trades + 1;
            // As above but with oracle price
            hourlyOraclePrices[currentHour].cumulativePrice =
                hourlyOraclePrices[currentHour].cumulativePrice +
                oraclePrice;
            hourlyOraclePrices[currentHour].trades = hourlyOraclePrices[currentHour].trades + 1;
        }
    }