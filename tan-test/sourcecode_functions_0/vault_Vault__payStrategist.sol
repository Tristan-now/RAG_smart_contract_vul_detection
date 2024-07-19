function _payStrategist(uint256 amount, address strategist) internal virtual;

    function _transfer(address to, uint256 amount) internal virtual;

    function _depositToReserve(uint256 amount) internal virtual;

    function _depositToTreasury(uint256 amount) internal virtual;

    function _availableUnderlying() internal view virtual returns (uint256);

    function _computeNewAllocated(uint256 allocated, uint256 withdrawn)
        internal
        pure
        returns (uint256)
    {
        if (allocated > withdrawn) {
            return allocated - withdrawn;
        }
        return 0;
    }