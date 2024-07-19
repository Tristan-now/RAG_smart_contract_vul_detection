import "./lib/LibPrices.sol";
import "./Interfaces/IOracle.sol";

contract Pricing is IPricing {
    // pricing metrics
    Prices.PriceInstant[24] internal hourlyTracerPrices;
    Prices.PriceInstant[24] internal hourlyOraclePrices;

    /**
     * @notice Updates pricing information given a trade of a certain volume at
     *         a set price
     * @param tradePrice the price the trade executed at
     */
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

    /**
     * @notice Updates both the latest market price and the latest underlying asset price (from an oracle) for a given tracer market given a tracer price
     *         and an oracle price.
     * @param marketPrice The price that a tracer was bought at, returned by the TracerPerpetualSwaps.sol contract when an order is filled
     * @param oraclePrice The price of the underlying asset that the Tracer is based upon as returned by a Chainlink Oracle
     * @param newRecord Bool that decides if a new hourly record should be started (true) or if a current hour should be updated (false)
     */
    function updatePrice(
        uint256 marketPrice,
        uint256 oraclePrice,
        bool newRecord
    ) internal {
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

}