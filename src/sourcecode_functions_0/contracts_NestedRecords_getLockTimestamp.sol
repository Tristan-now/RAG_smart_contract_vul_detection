function getLockTimestamp(uint256 _nftId) external view returns (uint256) {
        return records[_nftId].lockTimestamp;
    }