function _getPastDelegate(address account, uint256 blockNumber) internal view returns (address) {
        require(blockNumber < block.number, "hPAL: invalid blockNumber");

        // no checkpoints written
        uint256 nbCheckpoints = delegateCheckpoints[account].length;
        if (nbCheckpoints == 0) return address(0);

        // last checkpoint check
        if (delegateCheckpoints[account][nbCheckpoints - 1].fromBlock <= blockNumber) {
            return delegateCheckpoints[account][nbCheckpoints - 1].delegate;
        }

        // no checkpoint old enough
        if (delegateCheckpoints[account][0].fromBlock > blockNumber) return address(0);

        uint256 high = nbCheckpoints - 1; // last checkpoint already checked
        uint256 low = 0;
        uint256 mid;
        while (low < high) {
            mid = Math.average(low, high);
            if (delegateCheckpoints[account][mid].fromBlock == blockNumber) {
                return delegateCheckpoints[account][mid].delegate;
            }
            if (delegateCheckpoints[account][mid].fromBlock > blockNumber) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        return high == 0 ? address(0) : delegateCheckpoints[account][high - 1].delegate;
    }