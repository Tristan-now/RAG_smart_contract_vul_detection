function _addCommitment(address _addr, uint256 _commitment) internal {
        require(block.timestamp >= uint256(marketInfo.startTime) && block.timestamp <= uint256(marketInfo.endTime), "DutchAuction: outside auction hours");
        MarketStatus storage status = marketStatus;
        
        uint256 newCommitment = commitments[_addr].add(_commitment);
        if (status.usePointList) {
            require(IPointList(pointList).hasPoints(_addr, newCommitment));
        }
        
        commitments[_addr] = newCommitment;
        status.commitmentsTotal = BoringMath.to128(uint256(status.commitmentsTotal).add(_commitment));
        emit AddedCommitment(_addr, _commitment);
    }