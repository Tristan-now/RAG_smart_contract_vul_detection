function recordTrade(uint256 tradePrice) external override onlyTracer {
        uint256 currentOraclePrice = oracle.latestAnswer();
        if (startLastHour <= block.timestamp - 1 hours) {
            // emit the old hourly average
            uint256 hourlyTracerPrice = getHourlyAvgTracerPrice(currentHour);
            emit HourlyPriceUpdated(hourlyTracerPrice, currentHour);

            // update funding rate for the previous hour
            updateFundingRate();

            // update the time value
            if (startLast24Hours <= block.timestamp - 24 hours) {
                // Update the interest rate every 24 hours
                updateTimeValue();
                startLast24Hours = block.timestamp;
            }

            // update time metrics after all other state
            startLastHour = block.timestamp;

            // Check current hour and loop around if need be
            if (currentHour == 23) {
                currentHour = 0;
            } else {
                currentHour = currentHour + 1;
            }

            // add new pricing entry for new hour
            updatePrice(tradePrice, currentOraclePrice, true);
        } else {
            // Update old pricing entry
            updatePrice(tradePrice, currentOraclePrice, false);
        }
    }