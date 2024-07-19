function _checkpointsLookup(DelegateeCheckpoint[] storage ckpts, uint256 epochStart)
        private
        view
        returns (DelegateeCheckpoint memory)
    {
        uint256 high = ckpts.length;
        uint256 low = 0;
        while (low < high) {
            uint256 mid = AuraMath.average(low, high);
            if (ckpts[mid].epochStart > epochStart) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }

        return high == 0 ? DelegateeCheckpoint(0, 0) : ckpts[high - 1];
    }